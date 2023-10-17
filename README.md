testing commit
## Terraform/Ansible provisioning script to create an AWS EC2 instance with an Nginx docker container inside.

## Details

This repository sets up:

* A VPC
* Public and private subnets
* An internet gateway
* Security groups
* A publicly accessible EC2 instance running Ubuntu Server 18.04 LTS
* Nginx docker container running inside the EC2 instance


## Prerequisites
- Install the following locally:
provissioning
    * [Terraform](https://www.terraform.io/)
    * [Terraform Inventory](https://github.com/adammck/terraform-inventory)
    * [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
    * Ensure you add the key pair from aws to `terraform/keys` folder.
    * Ensure SSH agent has the AWS private key added  `ssh-add <path_to_key_file>` 
    

## Structure
```
.
├── ansible
│   ├── ansible.cfg
│   ├── playbook.retry
│   ├── playbook.yml
│   ├── scripts
│   │   ├── polkadot-fetch-output.sh
│   │   ├── polkadot-healthcheck.sh
│   │   └── polkadot-stats.sh
│   └── static-files
│       ├── 50x.html
│       └── index.html
├── deploy.sh
├── destroy.sh
├── README.md
└── terraform
    ├── instances
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── keys
    │   
    ├── main.tf
    ├── network
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── sg_groups.tf
    │   └── variables.tf
    ├── outputs.tf
    └── variables.tf

```

## Usage

```sh
./deploy.sh
```

## Cleanup

```sh
./destroy.sh
```

## Notes

A script to show health of the polkadot container exists in `/home/ubuntu/.scripts/polkadot-healthcheck.sh` folder.
```sh
root@ip-172-22-253-15:/home/ubuntu/.scripts# ./polkadot-healthcheck.sh 
Nginx healthy!
```

A script to fetch the output of the polkadot default HTTP page and print out the word that occurs most on the page (exclude HTML tags) exists in `/home/ubuntu/.scripts/polkadot-fetch-output.sh` folder.
```sh
root@ip-172-22-253-15:/home/ubuntu/.scripts# ./polkadot-fetch-output.sh 
Word that occurs most on the page:  is
```

Resource usage of the polkadot container exists in `/home/ubuntu/.polkadot/stats/resource-log.html` and the usage automaticatlly updates every 10 seconds.
```sh
root@ip-172-22-253-15:/home/ubuntu/.polkadot/stats# cat resource-log.html 
{"container":"polkadot","memory":{"raw":"2.16MiB / 983.9MiB","percent":"0.22%"},"cpu":"0.00%"}
```

Resource usage of the polkadot container `/home/ubuntu/.polkadot/stats/resource-log.html` also served via polkadot in http://<PUBLIC_DNS>/stats/resource-log.
```sh
root@ip-172-22-253-15:/home/ubuntu/.polkadot/stats# curl http://<PUBLIC_DNS>/stats/resource-log.html
{"container":"polkadot","memory":{"raw":"2.164MiB / 983.9MiB","percent":"0.22%"},"cpu":"0.00%"}
```

**Additional Notes**

You can add `terraform/terraform.tfvars` which contais runtime variables. If you don't have this file in place terraform will prompt for these values in the runtime.
```sh
access_key = "<access_key>"
secret_key = "<secret_key>"
region = "us-east-2"
aws_key_path = "<path_to_key>"
aws_key_name = "<key_name>"
```

## Risks

1. Creating the EC2 key pair manually and copying it to the source code location is not a good practice. This might be committed to a public repo by mistake. What can be done is to create the key-pair using terraform itself and using the AWS parameter store to store it and refer to its resource when performing instance related options. 

2. Using AWS credentials in *.tfvars file is not a good practice. This can be committed to a public repo by mistake, therefore, it is necessary to ensure that the .tfvars file is in the git config file as git ignore. This also can be done running terraform in a management node(EC2 instance) in AWS with a role that has permission/policies to created related resources.

3. Having terraform on the local machine or uploading scripts to the repo is not the best practice. The state file can also contain sensitive information like passwords. Therefore it is of good practice to use a feature in terraform that allows to store the state file in an S3 bucket and update it when changes are done.

4. Running containers without a container management platform can be risky, and not reliable. Containers can be killed due to various reasons. The better way of doing this to maintain your containers inside a container management platform such as Kubernetes / Openshift.


