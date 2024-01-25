data "aws_ami" "win_image" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202306212219"]
  }
}

data "aws_security_group" "wsj_prod_db" {
  filter {
    name   = "group-name"
    values = ["djcs-prod-wsja_con-db-sg"]
  }
}

data "aws_security_group" "djif-default-fi" {
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

data "aws_security_group" "AWS-CLN-WEB-sg" {
  filter {
    name   = "group-name"
    values = ["AWS-CLN-WEB-sg"]
  }
}

data "aws_security_group" "AWS-DIST-ADMIN-sg" {
  filter {
    name   = "group-name"
    values = ["AWS-DIST-ADMIN-sg"]
  }
}

data "aws_security_group" "AWS-JLS-WRWEB-sg" {
  filter {
    name   = "group-name"
    values = ["AWS-JLS-WRWEB-sg"]
  }
}

data "aws_security_group" "AWS-RC-Archive-sg" {
  filter {
    name   = "group-name"
    values = ["AWS-RC-Archive-sg"]
  }
}
