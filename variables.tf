######
# VPC
######
variable "vpc_cidr" {
  type        = string
  description = "The desired VPC CIDR block."
}

variable "subnet_mapping" {
  type = map(object({
    netmask      = number # The desired netmask of this subnet
    cidr_ordinal = number # The desired order of this subnet in relation to other subnets' CIDRs -- begin at 0
    az_ordinal   = number # The desired Availability Zone of this subnet as denoted by number -- begin at 0
  }))
  default     = {}
  description = "A map of objects that describe the subnets within the VPC."
}

#######
# Tags
#######
variable "tag_prefix" {
  type        = string
  description = "The string to add at the beginning of resource Name tags."
}
