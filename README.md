## Terraform/Ansible provisioning script to create an AWS EC2 instance with an Polkadot Validator docker container inside.

## Details

This repository sets up:

* A VPC
* Public and private subnets
* An internet gateway
* Security groups
* A publicly accessible EC2 instance running Ubuntu Server 20.04 LTS
* Polkadot Validator docker container running inside the EC2 instance


## Prerequisites
- Install the following locally:
provissioning
    * [Terraform](https://www.terraform.io/)
    * [Terraform Inventory](https://github.com/adammck/terraform-inventory)
    * [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
    * Ensure you add the key pair from aws to `~/.ssh/key.pem`.
    * Ensure SSH agent has the AWS private key added  `ssh-add ~/.ssh/key.pem`
 
```
Terraform v1.6.1
terraform-inventory version 0.9
ansible [core 2.15.3]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.9.16 (main, Sep  8 2023, 00:00:00) [GCC 11.4.1 20230605 (Red Hat 11.4.1-2)] (/usr/bin/python3.9)
  jinja version = 3.1.2
  libyaml = True

```
    

## Structure
```
.
├── ansible
│   ├── ansible.cfg
│   ├── playbook.yml
│   ├── group_vars
│   │   ├── polkadot.yml
├── deploy.sh
├── destroy.sh
├── README.md
└── terraform
    ├── instances
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
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

A command to show the version of the polkadot container:
```sh
docker exec polkadot-container polkadot --version 
polkadot-version 
```

A command to check the logs of the container.
```sh
docker logs polkadot-container -f
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

5.  Running polkadot container without a shared volume is too much effort, since the container will try to sync and it will take a lot of time. This time can be saved by sharing volume between container and ec2 instance.


