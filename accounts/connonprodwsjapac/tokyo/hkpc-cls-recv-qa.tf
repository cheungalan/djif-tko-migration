resource "aws_key_pair" "hkpc-cls-recv-key" {
  key_name   = "hkpc-cls-recv-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkpc-cls-recv"
}

data "aws_security_group" "djif-default-hkpc-cls-recv" {
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

resource "aws_security_group" "hkpc-cls-recv" {
  name        = "hkpc-cls-recv"
  description = "hkpc-cls-recv"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "hkpc-cls-recv"
    bu          = "djin"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djin/newswires/web"
    appid       = "in_newswires_djnews_clsdist"
    preserve    = "true"
  }

  ingress {
    description = "RDP from Global Protect Subnet"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.197.240.0/20", "10.169.144.0/20", "10.140.16.0/20", "10.32.120.0/24", "10.193.240.0/20", "10.199.240.0/20"]
  }

  ingress {
    description = "FTP from Global Protect Subnet"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["10.197.240.0/20", "10.169.144.0/20", "10.140.16.0/20", "10.32.120.0/24", "10.193.240.0/20", "10.199.240.0/20"]
  }

  ingress {
    description = "FTP-Data (Passive) from Global Protect Subnet"
    from_port   = 5000
    to_port     = 5100
    protocol    = "tcp"
    cidr_blocks = ["10.197.240.0/20", "10.169.144.0/20", "10.140.16.0/20", "10.32.120.0/24", "10.193.240.0/20", "10.199.240.0/20"]
  }

  ingress {
    description     = "TCP 8880 from lls-editor-qa / lls01-editor-qa"
    from_port       = 8880
    to_port         = 8880
    protocol        = "tcp"
    security_groups = ["sg-0666e6b567548c60b"]
  }

  /*
  ingress {
    from_port   = 139
    to_port     = 139
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
*/

  // Custom 20000-21000
  ingress {
    description = "Custom 20000 to 21000 from IDS2 QA server"
    from_port   = 20000
    to_port     = 21000
    protocol    = "tcp"
    cidr_blocks = ["10.151.54.0/23", "10.151.56.0/23"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description     = "FTP to cln-dist5-qa / cln-dist01-qa"
    from_port       = 21
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-0de67358259cbbc62"]
  }

  egress {
    description     = "FTP (Passive) to cln-dist5-qa / cln-dist01-qa"
    from_port       = 5000
    to_port         = 5100
    protocol        = "tcp"
    security_groups = ["sg-0de67358259cbbc62"]
  }

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
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /*
  egress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
*/

  egress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["10.13.32.134/32", "172.26.150.199/32"]
  }
}
