######
# VPC
######
variable "vpc_cidr" {
  type        = string
  description = "The desired VPC CIDR block."
}

variable "subnet_mapping" {
  type = map(object({
    netmask      = number      # The desired netmask of this subnet
    cidr_ordinal = number      # The desired order of this subnet in relation to other subnets' CIDRs -- begin at 0
    az_ordinal   = number      # The desired Availability Zone of this subnet as denoted by number -- begin at 0
    tags         = map(string) # The tags to apply to this subnet resource
  }))
  default     = {}
  description = "A map of objects that describe the subnets within the VPC."
}

#######
# Tags
#######
variable "vpc_tags" {
  type        = map(string)
  default     = {}
  description = "The tags to apply to the VPC resource."
}
