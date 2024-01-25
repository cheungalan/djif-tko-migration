resource "aws_security_group" "aws_jls_wrweb_sg" {
  name        = "aws-jls-wrweb-sg"
  description = "aws-jls-wrweb-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_jls_wrweb,
    {
      Name   = "${each.key}-root"
      ticket = "CT-15762"
    }
  )

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
    description     = "FTP self inbound access "
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    self            = true
  }

  ingress {
    description     = "FTP-Data (Passive) self inbound access"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    self            = true
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
    description     = "FTP self outbound access"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    self            = true
  }

  egress {
    description     = "FTP-Data (Passive) self outbound access"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    self            = true
  }

  egress {
    description = "SFTP access to nwsnonprodsftp[1-2].dowjones.com"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["52.23.88.222/32", "35.82.48.198/32"]
  }

  egress {
    description = "SFTP access to dj-ucpp-sftp-dev.dowjones.com"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["15.197.194.204/32", "3.33.195.45/32"]
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
}
