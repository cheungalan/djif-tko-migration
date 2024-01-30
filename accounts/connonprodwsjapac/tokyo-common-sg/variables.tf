variable "aws_region" {
  description = "Default Region for the VPC"
  default     = "ap-northeast-1"
}

variable "vpc_env" {
  description = "VPC Env"
  default     = "nonprod"
}

variable "account_id" {
  description = "AWS Account Number"
  default     = "830903312882"
}

variable "deployment_role" {
  description = "Name of role for deployment"
  default     = "djif-admin"
}

variable "TagEnv" {
  default = "nonprod"
}

variable "TagServiceName" {
  description = "Service Name"
  type        = string
  default     = "djin/newswires/web"
}

variable "TagOwner" {
  default = "Alan.Cheung@dowjones.com "
}

variable "TagBU" {
  default = "djin"
}

variable "TagProduct" {
  default = "newswires"
}

variable "TagComponent" {
  default = "web"
}

variable "appid" {
  default = "in_randc_web"
}
