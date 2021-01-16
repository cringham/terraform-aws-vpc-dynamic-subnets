locals {
  vpc_netmask         = tonumber(element(split("/", var.vpc_cidr), 1))
  subnet_mapping_keys = keys(var.subnet_mapping)
}

######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.tag_prefix}-vpc-1"
  }
}

#########
# Subnet
#########
data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "this" {
  for_each = var.subnet_mapping

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, each.value.netmask - local.vpc_netmask, each.value.cidr_ordinal)
  availability_zone = data.aws_availability_zones.this.names[each.value.az_ordinal]

  tags = {
    Name = "${var.tag_prefix}-subnet-${index(local.subnet_mapping_keys, each.key) + 1}"
  }
}
