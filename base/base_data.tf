data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "*.${var.vpc_env}.*.*-${var.vpc_env}"
  }
}

data "aws_subnets" "inet_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-inet-*a"]
  }
}

data "aws_subnets" "inet_c" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-inet-*c"]
  }
}

data "aws_subnets" "pro_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-pro-*a"]
  }
}

data "aws_subnets" "pro_c" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-pro-*c"]
  }
}

data "aws_subnets" "protected" {
  for_each = toset(["a", "c", "d"])

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-pro-*${each.value}"]
  }
}



// NCTCOMPUTE-3245
//NCTCOMPUTE-3123 so instances can be connected to win.dowjone.net and Shavlik...
data "aws_security_group" "djif-infrastructure-tools" { // this can be replaced with the `b_selected` for_each SG lookup
  filter {
    name   = "group-name"
    values = ["djif_infrastructure_tools"]
  }
}

data "aws_security_group" "djif-default" { // this can be replaced with the `b_selected` for_each SG lookup
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

data "aws_security_group" "b_selected" {
  for_each = setunion(compact(flatten([
    var.djif_std_security_group_names,
    var.c_security_group_names,
  ])))
  name = each.key
}
