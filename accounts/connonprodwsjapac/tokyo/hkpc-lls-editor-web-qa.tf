resource "aws_key_pair" "hkpc-lls-editor-web-key" {
  key_name   = "hkpc-lls-editor-web-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkpc-lls-editor-web"
}

data "aws_security_group" "djif-default-hkpc-lls-editor-web" {
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

resource "aws_security_group" "hkpc-lls-editor-web" {
  name        = "hkpc-lls-editor-web"
  description = "hkpc-lls-editor-web"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "hkpc-lls-editor-web"
    bu          = "djin"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djin/newswires/web"
    appid       = "in_newswires_web_lls"
    preserve    = "true"
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
    cidr_blocks = ["10.0.0.0/8", ]
  }

  ingress {
    description = "RDP from Global Protect Subnet"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.197.240.0/20", "10.169.144.0/20", "10.140.16.0/20", "10.32.120.0/24", "10.193.240.0/20", "10.199.240.0/20"]
  }

  ingress {
    description = "SSH from Global Protect Subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.197.240.0/20", "10.169.144.0/20", "10.140.16.0/20", "10.32.120.0/24", "10.193.240.0/20", "10.199.240.0/20"]
  }

  /*
  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

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

  ingress {
    from_port   = 20010
    to_port     = 20011
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.26.0.0/16", "192.168.0.0/16"]
  }
*/

  // Port 20010 - 20099
  ingress {
    description = "Custom 20010 to 20099 from IDS2 server"
    from_port   = 20010
    to_port     = 20099
    protocol    = "tcp"
    cidr_blocks = ["10.243.135.0/24", "10.243.6.0/24", "205.203.119.128/28", "205.203.122.128/28"]
  }

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

  /*
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
*/

  egress {
    description     = "TCP 8880 to cls-receiver-qa / cls-receiver01-qa"
    from_port       = 8880
    to_port         = 8880
    protocol        = "tcp"
    security_groups = ["sg-0c9287027c2363a33"]
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

  egress {
    description     = "Access to RDS cwsj-sql-qa.ckwswi0iistd.ap-northeast-1.rds.amazonaws.com"
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = ["sg-0f3e95285e196c776"]
  }

  /*
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
