variable "vpc_env" {
  description = "The environment of the vpc, valid inputs: `nonprod`, `stag` and `prod`"
  type        = string
}

variable "region_name" {
  description = "AWS region name. Example: `virginia`, `oregon`"
  type        = string
}

variable "vpc_id" {
  description = "The `ID` of the VPC"
  type        = string
}

variable "default_tags" {
  type = map(string)
}
