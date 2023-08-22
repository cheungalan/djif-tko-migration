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
    description = "Custom inbound from Newswires feeds"
    from_port   = 20000
    to_port     = 20100
    protocol    = "tcp"
    cidr_blocks = ["10.150.86.0/23", "10.150.88.0/23", "10.243.6.0/24", "10.243.135.0/24", "10.151.54.0/23", "10.151.56.0/23"]
  }

  ingress {
    description = "RDP inbound Access from all internal"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.26.0.0/16", "192.168.0.0/16"]
  }

  ingress {
    description = "FTP inbound access from internal"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // FTP-Pasv
  ingress {
    description = "FTP-Pasv self inboudn access"
    from_port   = 5000
    to_port     = 5100
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "NetBios inbound from internal"
    from_port   = 139
    to_port     = 139
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "SMB inbound from internal"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "MSSQL inbound from internal"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "ICMP from internal"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Dyanmic high ports outbound to DJ FTP"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["52.1.1.231/32"]
  }

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
    description     = "FTP access to CAS_App01_QA"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-02db8573b985e2d52"]
  }

  // FTP-Data to CAS_App01_QA
  egress {
    description     = "FTP-Data access to CAS_App01_QA"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["sg-02db8573b985e2d52"]
  }

  egress {
    description = "HTTP outbount to internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS outbount to internet"
    from_port   = 443
    to_port     = 443
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
    description = "DNS outbount to internal"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "DNS outbount to 162.0.0.0"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["162.0.0.0/8"]
  }

  egress {
    description = "DNS UDP outbound to internal"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "DNS UDP outbount to 162.0.0.0"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["162.0.0.0/8"]
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
    description = "ICMP outbound to any"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SMB outbout to internal"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "SMTP outbout to any" // need to revisit this 
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
