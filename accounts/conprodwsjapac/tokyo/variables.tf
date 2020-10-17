variable "aws_region" {
  description = "Default Region for the VPC"
  default     = "ap-northeast-1"
}

variable "vpc_env" {
  description = "VPC Env"
  default     = "prod"
}

variable "account_id" {
  description = "AWS Account Number"
  default = "261053699423"
}

variable "tko-rc-datagen_name" {
  default = "tko-rc-datagen"
}

variable "deployment_role" {
  description = "Name of role for deployment"
  default = "djif-admin"
}

variable "tko-rc-datagen_subnet_id" {
  default = "subnet-01908a38bc2ac7a5b"
}

variable "tko-rc-datagen_instance_type" {
  default = "t3.large" 
}

variable "root_v_type" {
  default = "gp2"
}

variable "root_v_size" {
  default = "300"
}

variable "TagEnv" {
  default = "prod"
}

variable "TagServiceName" {
  description = "Service Name"
  type        = "string"
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
