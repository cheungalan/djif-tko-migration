output "smtp" {
  value = var.smtp
}

variable "smtp" {
  type = list(string)
  default = [
    "10.13.32.134/32",   #smtp.dowjones.net
    "172.26.150.199/32", # smtp2.dowjones.net, redundant to smtp.dowjones.net
  ]
}

