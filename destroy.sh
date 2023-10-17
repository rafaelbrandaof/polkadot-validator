#!/bin/bash

set -e
set -x

# set up the infrastructure
cd terraform
terraform destroy -auto-approve
