# networking/main.tf

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-vpc-${random_integer.random.id}"
    })
  )

}

resource "aws_subnet" "mtc_public_subnet_AZ_c" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-public-az-a-${random_integer.random.id}"
    })
  )
}

resource "aws_route_table_association" "mtc_public_associate" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.mtc_public_subnet_AZ_c.*.id[count.index]
  route_table_id = aws_route_table.mtc_public_RT.id
}

resource "aws_subnet" "mtc_private_subnet_AZ_a" {
  count                   = var.private_sn_count - 2
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-private-az-a-${count.index}"
    })
  )
}

resource "aws_subnet" "mtc_private_subnet_AZ_c" {
  count                   = var.private_sn_count - 2
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private_cidrs[count.index + 2]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-private-az-c-${count.index + 2}"
    })
  )
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-IGW"
    })
  )
}

resource "aws_route_table" "mtc_public_RT" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-public-RT"
    })
  )
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_default_route_table" "mtc_private_RT" {
  default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-private-RT"
    })
  )
}

resource "aws_security_group" "mtc_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id



  #public Security Group
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.prefix}-security-group"
    })
  )
}

resource "aws_db_subnet_group" "mtc_rds_subnetgroup" {
	count = var.db_subnet_group == true ? 1:0
	name = "mtc_rds_subnetgroup"
	subnet_ids = [aws_subnet.mtc_private_subnet_AZ_a[1].id, aws_subnet.mtc_private_subnet_AZ_c[1].id]
	tags = merge(
		local.common_tags,
		tomap({
		"Name" = "${local.prefix}-rds_subnetgroup-private"
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
