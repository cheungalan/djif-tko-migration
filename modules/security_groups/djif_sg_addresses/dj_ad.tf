output "dj_adc_all" {
  value = flatten([
    split(",", join(",", values(var.dj_adc_all)))
  ])
}

variable "dj_adc_all" {
  type = map(string)
  default = {
    virginia = "10.146.80.0/20"
  }
}

