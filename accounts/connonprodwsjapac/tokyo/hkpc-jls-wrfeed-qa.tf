resource "aws_key_pair" "hkpc-jls-wrfeed-key" {
  key_name   = "hkpc-jls-wrfeed-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkpc-jls-wrfeed"
}

data "aws_security_group" "djif-default-hkpc-jls-wrfeed" {
  filter {
    name   = "group-name"
    values = ["djif_default"]
  }
}

resource "aws_security_group" "hkpc-jls-wrfeed" {
  name        = "hkpc-jls-wrfeed"
  description = "hkpc-jls-wrfeed"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "hkpc-jls-wrfeed"
    bu          = "djin"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djin/newswires/web"
    appid       = "in_newswires_web_jlswireryter"
    preserve    = "true"
  }

  ingress {
    description = "Custom 20000 to 21000 from IDS2 QA server"
    from_port   = 20000
    to_port     = 20100
    protocol    = "tcp"
    cidr_blocks = ["10.150.86.0/23", "10.150.88.0/23", "10.151.54.0/23", "10.151.56.0/23"]
  }

  ingress {
    description = "Custom 20000 to 21000 from IDS2 Production server"
    from_port   = 20000
    to_port     = 20100
    protocol    = "tcp"
    cidr_blocks = ["10.243.6.0/24", "10.243.135.0/24"]
  }

  ingress {
    description = "RDP from Global Protect Subnet"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.197.240.0/20", "10.169.144.0/20", "10.140.16.0/20", "10.32.120.0/24", "10.193.240.0/20", "10.199.240.0/20"]
  }

  ingress {
    description     = "MSSQL from hkpk-jls-web2-qa1"
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = ["sg-0a95e25d5d66b4e65"]
  }

  ingress {
    description     = "FTP access from JLS-WRFEED-QA"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-0f27d915082a302b7"]
  }

  ingress {
    description     = "FTP-Data access from JLS-WRFEED-QA"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["sg-0f27d915082a302b7"]
  }

  ingress {
    description = "ICMP from internal"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description     = "SFTP access to hkpk-secure-wsj-asia-qa1"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-0b1cbfac81a5eaabf"]
  }

  egress {
    description = "FTP access to DJ FTP (ftp.dowjones.com)"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["52.1.1.231/32"]
  }

  egress {
    description = "FTP-Data access to DJ FTP (ftp.dowjones.com)"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["52.1.1.231/32"]
  }

  egress {
    description     = "FTP access to CAS_App01_QA"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-02db8573b985e2d52"]
  }

  egress {
    description     = "FTP-Data access to CAS_App01_QA"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["sg-02db8573b985e2d52"]
  }

  egress {
    description     = "FTP access to JLS-WRFEED-QA"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-0f27d915082a302b7"]
  }

  egress {
    description     = "FTP-Data access to JLS-WRFEED-QA"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["sg-0f27d915082a302b7"]
  }

  egress {
    description = "SFTP access to nwsnonprodsftp[1-2].dowjones.com"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["52.23.88.222/32", "35.82.48.198/32"]
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
    description     = "MySQL Access to RDS djcs-wsja-rds-qa.cluster-ckwswi0iistd.ap-northeast-1.rds.amazonaws.com"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-01536f4a5ec7e6519"]
  }

  egress {
    description     = "MySQL Access to hkpk-jls-wrweb-qa"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-0d7db14df788b8f46"]
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
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["10.13.32.134/32", "172.26.150.199/32"]
  }

/*
  egress {
    description = "Dyanmic high ports outbound to 152.1.1.231"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["152.1.1.231/32"]
  }

  egress {
    description = "Dyanmic high ports outbound to 10.32.176.211"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.32.176.211/32"]
  }

  // FTP-Data
  egress {
    description = "FTP-Data outbound self access"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "MSSQL outbount access to internal"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "FTP SFTP outbound to internet"
    from_port   = 21
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "MySQL outbount to internal"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "NTP outbound to any"
    from_port   = 123
    to_port     = 123
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "NTP UDP outbound to any"
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SMB outbout to internal"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
*/

}

data "aws_ami" "hkpc-jls-wrfeed" {
  most_recent = true
  owners      = ["819633815198"]
  filter {
    name   = "name"
    values = ["DJW2K19DC_VANILLA_PACKER_CHEF12*"]
  }
}

resource "aws_instance" "hkpc-jls-wrfeed" {
  ami                    = data.aws_ami.hkpc-jls-wrfeed.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.hkpc-jls-wrfeed-key.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-jls-wrfeed.id, aws_security_group.hkpc-jls-wrfeed.id]


  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
    tags = {
      Name        = "${var.hkpc-jls-wrfeed-name}-root"
      bu          = "djin"
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = var.TagProduct
      component   = var.TagComponent
      servicename = "djin/newswires/web"
      appid       = "in_newswires_web_jlswireryter"
    }
  }

  tags = {
    Name        = var.hkpc-jls-wrfeed-name
    bu          = "djin"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djin/newswires/web"
    appid       = "in_newswires_web_jlswireryter"
    autosnap    = "bkp=a"
    preserve    = true
  }
}
