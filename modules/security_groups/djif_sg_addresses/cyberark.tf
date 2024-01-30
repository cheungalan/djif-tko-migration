output "cyberark" {
  value = var.cyberark
}

variable "cyberark" {
  type = list(string)
  default = [
    "10.212.122.104/30",
    "10.212.122.107/32",
    "10.214.122.104/30",
    "10.146.86.15/32"
  ]
}

