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

variable "vpc_id" {
  description = "VPC Id"
  default = "vpc-09745522ce354a0f3"
}

variable "tko_rc_datagen_name" {
  default = "tko-rc-datagen"
}

variable "tko_rc_web_name" {
  default = "tko-rc-web"
}

variable "hkg_jswj_archive_name" {
  default = "hkg-jwsj-archive"
}

variable "hkg_financial_inclusion_name" {
  default = "hkg-financial-inclusion"
}

variable "infoscreen_name" {
  default = "infoscreen"
}

variable "deployment_role" {
  description = "Name of role for deployment"
  default = "djif-admin"
}

variable "tko_rc_datagen_subnet_id" {
  default = "subnet-01908a38bc2ac7a5b"
}

variable "tko_rc_web_subnet_id" {
  default = "subnet-01908a38bc2ac7a5b"
}

variable "hkg_jswj_archive_subnet_id" {
  default = "subnet-01908a38bc2ac7a5b"
}

variable "hkg_financial_inclusion_subnet_id" {
  default = "subnet-01908a38bc2ac7a5b"
}

variable "infoscreen_subnet_id" {
  default = "subnet-01908a38bc2ac7a5b"
}

variable "tko_rc_datagen_instance_type" {
  default = "t3.large" 
}

variable "tko_rc_web_instance_type" {
  default = "t3.large" 
}

variable "hkg_jswj_archive_instance_type" {
  default = "t3.large"
}

variable "hkg_financial_inclusion_instance_type" {
  default = "t3.large"
}

variable "infoscreen_instance_type" {
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
