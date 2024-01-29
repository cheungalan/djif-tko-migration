resource "aws_security_group" "aws_cas_web_sg" {
  name        = "AWS-CAS-Web-sg"
  description = "AWS-CAS-Web-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_cas_web,
    {
      Name     = "AWS-CAS-Web-sg"
      preserve = true
      ticket   = "CT-15762"
    }
  )

  // Web Access 80
  ingress {
    description = "HTTP access from internal"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // Web Access 443
  ingress {
    description = "HTTPS access from internal"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // SSH Access
  ingress {
    description = "SSH Access from Global Protect Subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.197.242.0/23", "10.197.244.0/23", "10.169.146.0/23", "10.169.148.0/23", "10.140.16.0/20", "10.32.120.0/24", "10.193.242.0/23", "10.193.244.0/23", "10.193.246.0/23", "10.199.242.0/23", "10.199.244.0/23"]
  }

  /*
  // MYSQL
  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
*/

  // ICMP
  ingress {
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

  // DNS TCP
  egress {
    description = "DNS TCP"
    from_port   = "53"
    to_port     = "53"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // DNS UDP
  egress {
    description = "DNS UDP"
    from_port   = "53"
    to_port     = "53"
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // SMTP
  egress {
    description = "SMTP Access"
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

  egress {
    description     = "MySQL Access to RDS djcs-wsja-rds-qa.cluster-ckwswi0iistd.ap-northeast-1.rds.amazonaws.com"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-01536f4a5ec7e6519"]
  }

  /*
  // SSH Access
  egress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // NTP TCP
  egress {
    description = "NTP TCP"
    from_port   = "123"
    to_port     = "123"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8","172.26.0.0/16","192.168.0.0/16"]
  }

  // NTP UDP
  egress {
    description = "NTP UDP"
    from_port   = "123"
    to_port     = "123"
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8","172.26.0.0/16","192.168.0.0/16"]
  }
*/

}
