data "aws_security_group" "djif-default-datagen" {
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

//NCTCOMPUTE-3123 so instances can be connected to win.dowjone.net and Shavlik...
data "aws_security_group" "djif-infrastructure-tools" {
  filter {
    name   = "group-name"
    values = ["djif_infrastructure_tools"]
  }
}

resource "aws_security_group" "djif-datagen-sg" {
  name        = "djif-datagen-sg"
  description = "djif-datagen-sg"

  vpc_id = var.vpc_id

  tags = {
    Name        = "djif-datagen-sg"
    bu          = var.TagBU
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = var.TagServiceName
    appid       = "in_platform_randc_datagenjapan"
    preserve    = "true"
  }

  //IP-6495

  // ICMP
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // RDP Access
  ingress {
    description = "RDP Access from Global Protect"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.197.242.0/23", "10.197.244.0/23", "10.169.146.0/23", "10.169.148.0/23", "10.146.86.15/32", "10.140.16.0/20", "10.32.120.0/24"]
  }

  // FTP Access 21
  ingress {
    description = "FTP Access 21 from Global Protect"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["10.197.242.0/23", "10.197.244.0/23", "10.169.146.0/23", "10.169.148.0/23",   "10.140.16.0/20", "10.32.120.0/24"]
  }

  // FTP Access 21
  ingress {
    description = "FTP Access 21 from DJ Proxy"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["113.43.214.99/32", "205.203.99.34/32", "205.203.99.41/32", "203.116.229.70/32", "202.106.222.158/32"]
  }

  // FTP Access 21
  ingress {
    description     = "FTP Access 21 from TKO-RC-WEB"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-06e24f4c64f2dad71"]
  }

  // SMB Access
  ingress {
    description = "SMB Access from Global Protect"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.197.242.0/23", "10.197.244.0/23", "10.169.146.0/23", "10.169.148.0/23", "10.140.16.0/20", "10.32.120.0/24"]
  }

  egress {
    description = "FTP Access to TKO-RC-WEB"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["13.113.112.91/32", "54.178.254.191/32"]
  }

  egress {
    description     = "FTP Access to TKO-RC-WEB"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-06e24f4c64f2dad71"]
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

  egress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["10.13.32.134/32", "172.26.150.199/32"]
  }

  egress {
    description = "TELNET to hkgproxy.dowjones.net"
    from_port   = 23
    to_port     = 23
    protocol    = "tcp"
    cidr_blocks = ["10.32.2.39/32"]
  }

  // SSH
  egress {
    description     = "SSH access to TKO-RC-WEB"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-06e24f4c64f2dad71"]
  }

  // Allow rDS access
  egress {
    description     = "Access to RDS djcs-wsja-rds-prod.cluster-c1qsnfwzpreu.ap-northeast-1.rds.amazonaws.com"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [data.aws_security_group.wsj_prod_db.id]
  }
}