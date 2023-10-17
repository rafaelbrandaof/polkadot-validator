#!/bin/bash

set -e
set -x

# set up the infrastructure
cd terraform
terraform init
terraform apply -auto-approve

# provision the instance
cd ../ansible

# pull the instance information from Terraform, and run the Ansible playbook against it to configure
terraform-inventory -inventory ../terraform/. > hosts.ini

ansible-playbook -i hosts.ini playbook.yml -u ubuntu --private-key ~/.ssh/ec2-test.pem
