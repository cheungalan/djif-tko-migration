variable "vpc_env" {
  description = "The environment of the vpc, valid inputs: `nonprod`, `stag` and `prod`"
  type        = string
}

variable "region_name" {
  description = "The name of the region. Example value: `virginia`, `oregon`"
  type        = string
}
