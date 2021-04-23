###########
# Provider
###########
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "personal"
}

#########
# Module
#########
module "network" {
  source = "./.."

  vpc_cidr = "172.16.0.0/24"
  subnet_mapping = {
    web1 = {
      netmask      = 28 # "I want this to be a x.x.x.x/28 subnet"
      cidr_ordinal = 0  # "If I split my entire VPC CIDR into ordered /28 blocks, I want this subnet to claim the 1st /28 block" -- evaluates to 172.16.0.0/28 here
      az_ordinal   = 0  # "I want this subnet to be associated with the 1st AZ for my region"
      tags = {
        Name = "aws-subnet-useast-web-test-1a"
      }
    }
    web2 = {
      netmask      = 28 # "I want this to be a x.x.x.x/28 subnet"
      cidr_ordinal = 1  # "If I split my entire VPC CIDR into ordered /28 blocks, I want this subnet to claim the 2nd /28 block" -- evaluates to 172.16.0.16/28 here
      az_ordinal   = 1  # "I want this subnet to be associated with the 2nd AZ for my region"
      tags = {
        Name = "aws-subnet-useast-web-test-1b"
      }
    }
    db1 = {
      netmask      = 27 # "I want this to be a x.x.x.x/27 subnet"
      cidr_ordinal = 1  # "If I split my entire VPC CIDR into ordered /27 blocks, I want this subnet to claim the 2nd /27 block" -- evaluates to 172.16.0.32/27 here
      az_ordinal   = 1  # "I want this subnet to also be associated with the 2nd AZ for my region"
      tags = {
        Name = "aws-subnet-useast-db-test-1b"
      }
    }
  }

  vpc_tags = {
    Name = "aws-vpc-useast-test"
  }
}

###############
# Using Output
###############

# TGW example
resource "aws_ec2_transit_gateway" "this" {
  description                     = "TGW to connect Test VPCs"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "aws-tgw-useast-test"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  vpc_id     = module.network.vpc.id
  subnet_ids = [module.network.subnets.web1.id]

  tags = {
    Name = "aws-tgwattch-useast-test"
  }
}

# Route Table example
resource "aws_route_table" "this" {
  vpc_id = module.network.vpc.id

  tags = {
    Name = "aws-rt-useast-test"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = module.network.subnets.web1.id
  route_table_id = aws_route_table.this.id
}

# EC2 Instance example
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  root_block_device {
    encrypted = true
    tags = {
      Name = "aws-vol-useast-test-root-1a"
    }
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.this.id
  }

  tags = {
    Name = "aws-instance-useast-test-1a"
  }
}

resource "aws_network_interface" "this" {
  subnet_id   = module.network.subnets.web1.id
  description = "Primary ENI of Test Instance"

  tags = {
    Name = "aws-eni-useast-test-1a-eth0"
  }
}

# etc...
