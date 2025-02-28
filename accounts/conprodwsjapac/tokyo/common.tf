data "aws_ami" "win_image" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202306212219"]
  }
}

data "aws_ami" "amigo_amzn_linux2023" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-amzn_linux-2023-dowjones-base-202404031423"]
  }
}

data "aws_security_group" "wsj_prod_db" {
  filter {
    name   = "group-name"
    values = ["djcs-prod-wsja_con-db-sg"]
  }
}

data "aws_security_group" "djif_default" {
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

