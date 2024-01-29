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

data "aws_ami" "amigo_amzn_linux2023" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-amzn_linux-2023-dowjones-base-202401042335"]
  }
}

// NCTCOMPUTE-3245
//NCTCOMPUTE-3123 so instances can be connected to win.dowjone.net and Shavlik...
data "aws_security_group" "djif-infrastructure-tools" {
  filter {
    name   = "group-name"
    values = ["djif_infrastructure_tools"]
  }
}
