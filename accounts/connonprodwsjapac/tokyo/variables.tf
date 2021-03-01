variable "aws_region" {
  description = "Default Region for the VPC"
  default     = "ap-northeast-1"
}

variable "vpc_id" {
  description = "VPC Id"
  default     = "vpc-06aafb8a1a86a46c1"
}

variable "account_id" {
  description = "AWS Account Number"
  default = "830903312882"
}

variable "hkpc-cwsj-mobile-converter-qa-name" {
  default = "hkpc-cwsj-mobile-converter-qa"
}

variable "hkpc-secure-wsj-asia-qa-name" {
  default = "hkpc-secure-wsj-asia-qa"
}

variable "hkpc-infosceen-qa-name" {
  default = "hkpc-infosceen-qa"
}

variable "hkpk-cwsj-enews-tools-qa-name" {
  default = "hkpk-cwsj-enews-tools-qa"
}

variable "hkpk-newsnet-qa-name" {
  default = "hkpk-newsnet-qa"
}

variable "hkpk-tko-rc-04-qa-name" {
  default = "hkpk-tko-rc-04-qa"
}

variable "hkpc-dist-admin-qa-name" {
  default = "hkpc-dist-admin-qa"
}

variable "hkpc-financialinclusion-qa-name" {
  default = "hkpc-financialinclusion-qa"
}

variable "hkpk-jls-web2-qa-name" {
  default = "hkpk-jls-web2-qa"
}

variable "deployment_role" {
  description = "Name of role for deployment"
  default = "djif-admin"
}

variable "subnet_id" {
  default = "subnet-0332fe843400c1728"
}

variable "instance_type" {
  default = "t3.medium" 
}

variable "root_v_type" {
  default = "gp2"
}

variable "root_v_size" {
  default = "200"
}

variable "TagEnv" {
  default = "qa"
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

variable "hkpc-cwsj-editor-web-name" {
  default = "editor-web-qa"
}

variable "hkpc-cwsj-sql-name" {
  default = "cwsj-sql-01-qa"
}

variable "hkpc-lls-editor-web-name" {
  default = "lls-edit-web-qa"
}

variable "hkpc-cln-dist-name" {
  default = "cln-dist-5-qa"
}

variable "hkpc-jls-wrfeed-name" {
  default = "jls-wrfeed-1-qa"
}

variable "hkpc-cls-recv-name" {
  default = "cls-recv-02-qa"
}

variable "hkpc-cwsj-ftp-gateway-name" {
  default = "cwsj-ftp-gat-qa"
}
