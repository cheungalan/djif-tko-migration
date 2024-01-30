output "same_env_same_region" {
  value = split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_${var.region_name}_all"))
}

output "same_env_same_region_inet" {
  value = split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_${var.region_name}_inet"))
}

output "same_env_same_region_pri" {
  value = split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_${var.region_name}_pri"))
}

output "same_env_same_region_pro" {
  value = split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_${var.region_name}_pro"))
}

output "same_env_all_regions" {
  value = flatten([
    split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_virginia_all")),
    var.vpc_env == "nonprod" ? [] : split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_oregon_all")),
  ])
}

output "same_env_all_regions_inet" {
  value = flatten([
    split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_virginia_inet")),
    var.vpc_env == "nonprod" ? [] : split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_oregon_inet")),
  ])
}

output "same_env_all_regions_pri" {
  value = flatten([
    split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_virginia_pri")),
    var.vpc_env == "nonprod" ? [] : split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_oregon_pri")),
  ])
}

output "same_env_all_regions_pro" {
  value = flatten([
    split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_virginia_pro")),
    var.vpc_env == "nonprod" ? [] : split(",", lookup(local.wsjapac_lz, "${var.vpc_env}_oregon_pro")),
  ])
}


output "all_internal" {
  value = local.all_internal
}

output "all_global_protect" {
  value = local.all_global_protect
}
