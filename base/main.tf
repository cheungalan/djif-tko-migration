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