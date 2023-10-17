variable "ubuntu_ami" {}

variable "private_subnets_ids" {}

variable "public_subnets_ids" {}

variable "polkadot_instance_type" {}

variable "name" {}

variable "aws_key_path" {}

variable "aws_key_name" {}

variable "security_group_ids" {}

variable "number_of_vms" {
  description = "Number of ec2 instances"
  type        = integer
  default     = 2
}
