resource "aws_eip" "polkadot_eip" {
  depends_on = [aws_instance.polkadot_instance]
  domain     = "vpc"
}

resource "aws_instance" "polkadot_instance" {

  count                  = var.number_of_vms
  ami                    = "${var.ubuntu_ami}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  subnet_id              = "${element(split(",", var.public_subnets_ids), count.index)}"
  instance_type          = "${var.polkadot_instance_type}"
  key_name               = "${var.aws_key_name}"
  
  tags = {
    Name = "${var.name}_polkadot-instance"
  }
}
