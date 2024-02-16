variable "c_security_group_names" {
  description = "Optional: A list of `Name` of security groups from the account specific VPC"
  type        = list(string)
  default     = []
}


variable "djif_std_security_group_names" {
  description = "A list of `Name` of DJ standard security groups"
  type        = list(string)
  default     = ["djif_infrastructure_tools", "djif_default"]
}
