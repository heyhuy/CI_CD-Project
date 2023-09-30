data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230912.0-kernel-6.1-x86_64"]
  }

}

resource "random_id" "mtc_node_id" {
  byte_length = 2
  count       = var.instance_count
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "mtc_node" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = var.public_sg
  subnet_id              = var.public_subnets[count.index]
  # user_data              = ""

  root_block_device {
    volume_size = var.vol_size
  }

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-EC2-instance"
    })
  )
}




locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owners      = var.contact
    ManagedBy   = "terraform"
  }
}
