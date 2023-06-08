
// Bring back tfstate in sync

resource "aws_eip" "tko-rc-web-eip" {
  count  = 3
  domain = "vpc"
}

resource "aws_eip_association" "tko-rc-web-eip-assoc" {
  count               = 3
  instance_id         = element(aws_instance.tko-rc-web.*.id, count.index)
  allocation_id       = element(aws_eip.tko-rc-web-eip.*.id, count.index)
  allow_reassociation = false
}


resource "aws_key_pair" "tko_rc_web_key" {
  key_name   = "tko_rc_web_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== tko-rc-web"
}

data "aws_ami" "tko_rc_web_image" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-centos-7-dowjones-base-202305010920"]
  }
}

data "aws_ami" "tko_rc_web_image_old" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-centos-7-dowjones-base-202010190921"]
  }
}

data "aws_security_group" "djif-default-web" {
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

resource "aws_security_group" "djif-rc-web-sg" {
  name        = "djif-rc-web-sg"
  description = "djif-rc-web-sg"

  vpc_id = var.vpc_id

  //IP-6495

  // Web Access 80
  ingress {
    description = "Web Access 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Web Access 443
  ingress {
    description = "Web Access 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH Access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.197.242.0/23", "10.197.244.0/23", "10.169.146.0/23", "10.169.148.0/23", "113.43.214.99/32", "205.203.99.34/32", "205.203.99.41/32", "203.116.229.70/32", "202.106.222.158/32", "10.167.16.0/24", "10.167.17.0/24", "10.167.20.0/24", "10.167.22.0/24", "10.32.212.66/32", "10.140.16.0/20", "10.32.120.0/24"]
  }

  ingress {
    description = "FTP Access"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["10.167.16.34/32", "10.167.16.226/32", "10.167.16.181/32", "10.167.16.250/32"]
  }

  // ICMP 
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // SMTP
  egress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["10.13.32.134/32", "172.26.150.199/32"]
  }

  // ICMP 
  egress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // Internet Access 80
  egress {
    description = "Internet Access 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Internet Access 443
  egress {
    description = "Internet Access 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow rDS access 
  egress {
    description     = "Access to RDS djcs-wsja-rds-prod.cluster-c1qsnfwzpreu.ap-northeast-1.rds.amazonaws.com"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [data.aws_security_group.wsj_prod_db.id]
  }

  tags = {
    Name        = "djif-rc-web-sg"
    bu          = var.TagBU
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = var.TagServiceName
    appid       = "in_platform_randc_datagenjapan"
    preserve    = "true"
  }
}

/*
resource "aws_security_group_rule" "allow_rds_web_egress" {
    description = "Access to RDS"
    security_group_id        = "${aws_security_group.djif-rc-web-sg.id}"
    type                     = "egress"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    source_security_group_id = data.aws_security_group.wsj_prod_db.id
}
*/

resource "aws_instance" "tko-rc-web" {
  count = 3
  // keep the same config AMI  for the first two instances and let the new instances use the current AMI
  ami                    = count.index < 2 ? data.aws_ami.tko_rc_web_image_old.image_id : data.aws_ami.tko_rc_web_image.image_id
  instance_type          = var.tko_rc_web_instance_type
  key_name               = aws_key_pair.tko_rc_web_key.id
  subnet_id              = var.tko_rc_web_subnet_ids[count.index]
  vpc_security_group_ids = [data.aws_security_group.djif-default-web.id, aws_security_group.djif-rc-web-sg.id]

  root_block_device {
    delete_on_termination = false
    volume_size           = var.root_v_size
    volume_type           = var.root_v_type
    tags = {
      Name        = "tko-rc-web2"
      vollockname = "tko_rc_web_key-orig"
      bu          = var.TagBU
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = var.TagProduct
      component   = var.TagComponent
      servicename = var.TagServiceName
      appid       = "in_platform_randc_datagenjapan"
    }
  }

  tags = {
    Name        = "${var.tko_rc_web_name}${count.index + 1}"
    bu          = var.TagBU
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = var.TagServiceName
    appid       = "in_platform_randc_datagenjapan"
    preserve    = true
    autosnap    = "bkp=o"
  }
}
