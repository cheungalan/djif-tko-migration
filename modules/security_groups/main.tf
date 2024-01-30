locals {
  nonprod = var.vpc_env == "nonprod"
  stag    = var.vpc_env == "stag"
  prod    = var.vpc_env == "prod"

  env_tag_by_env = {
    nonprod = "dev"
    stag    = "stag"
    prod    = "prod"
  }
}

module "dj_sg_addresses" {
  source = "./djif_sg_addresses"
}

module "addresses" {
  source = "./addresses"

  vpc_env     = var.vpc_env
  region_name = var.region_name
}
