output "commvault" {
  value = var.commvault
}

variable "commvault" {
  type = list(string)
  default = [
    "10.149.186.0/24",
    "10.220.8.0/24"
  ]
}
