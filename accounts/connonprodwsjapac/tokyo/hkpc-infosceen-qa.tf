resource "aws_key_pair" "hkpc-infosceen-qa-key" {
  key_name   = "hkpc-infosceen-qa-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkpc-infosceen-qa"
}

resource "aws_security_group" "hkpc-infosceen-qa" {
  name        = "hkpc-infosceen-qa"
  description = "hkpc-infosceen-qa"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "hkpc-infosceen-qa"
    bu          = "djcs"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djcs/wsj/web"
    appid       = "djcs_wsj_web_infoscreen"
    preserve    = "true"
  }

  ingress {
    description = "SSH Access from Global Protect Subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.197.242.0/23", "10.197.244.0/23", "10.169.146.0/23", "10.169.148.0/23", "10.140.16.0/20", "10.32.120.0/24", "10.193.242.0/23", "10.193.244.0/23", "10.193.246.0/23", "10.199.242.0/23", "10.199.244.0/23"]
  }

  ingress {
    description = "HTTP access from internal"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "HTTPS access from internal"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

/*
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
*/

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

/*
  egress {
    from_port   = 21
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
*/

  egress {
    description = "Internet Access 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Internet Access 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Access to RDS djcs-wsja-rds-qa.cluster-ckwswi0iistd.ap-northeast-1.rds.amazonaws.com"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-01536f4a5ec7e6519"]
  }

  egress {
    description = "DNS Access"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "DNS Access"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "NTP Access"
    from_port   = 123
    to_port     = 123
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "NTP Access"
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "hkpc-infosceen-qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-centos-7-dowjones-base-202010190921"]
  }
}

resource "aws_instance" "hkpc-infosceen-qa" {
  count                  = 1
  ami                    = data.aws_ami.hkpc-infosceen-qa.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.hkpc-infosceen-qa-key.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.hkpc-infosceen-qa.id]

  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
    tags = {
      Name        = "${var.hkpc-infosceen-qa-name}${count.index + 1}-root"
      bu          = "djcs"
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = var.TagProduct
      component   = var.TagComponent
      servicename = "djcs/wsj/web"
      appid       = "djcs_wsj_web_infoscreen"
    }
  }

  tags = {
    Name        = "${var.hkpc-infosceen-qa-name}${count.index + 1}"
    bu          = "djcs"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djcs/wsj/web"
    appid       = "djcs_wsj_web_infoscreen"
    autosnap    = "bkp=a"
    preserve    = true
  }
}
