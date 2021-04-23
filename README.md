# terraform-aws-vpc-dynamic-subnets

A simple module to provision a VPC and associated subnets without any CIDR calculations on your part.

## About

This module creates:
- 1 VPC
- Varying subnets based on user input

See the `~/examples` dir for examples on using this module.

## Input

| Name             | Type                                                                                                | Default | Description                                               |
| ---------------- | --------------------------------------------------------------------------------------------------- | ------- | --------------------------------------------------------- |
| `vpc_cidr`       | `string`                                                                                            | N/A     | The desired VPC CIDR block                                |
| `subnet_mapping` | `map(object({ netmask = number, cidr_ordinal = number, az_ordinal = number, tags = map(string) }))` | `{}`    | A map of objects that describe the subnets within the VPC |
| `vpc_tags`       | `map(string)`                                                                                       | `{}`    | The tags to apply to the VPC resource                     |

## Output

| Name      | Description                      |
| --------- | -------------------------------- |
| `vpc`     | The VPC resource object          |
| `subnets` | A map of subnet resource objects |

## Meta

This module was developed and tested using Terraform CLI v0.15.0.
