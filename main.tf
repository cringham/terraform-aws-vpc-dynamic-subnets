locals {
  vpc_netmask = tonumber(element(split("/", var.vpc_cidr), 1))
}

######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = var.vpc_tags
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

  tags = each.value.tags
}
