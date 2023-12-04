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
