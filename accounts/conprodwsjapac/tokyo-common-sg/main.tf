module "sg" {
  source       = "../../../../modules/security_groups"
  vpc_env      = var.vpc_env
  region_name  = local.region_name_by_id[var.aws_region]
  vpc_id       = data.aws_vpc.vpc.id
  default_tags = local.default_tags
}
