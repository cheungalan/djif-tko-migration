resource "aws_security_group" "wsjapac-default-sg" {
  count       = local.nonprod || local.prod ? 1 : 0 // this sg to be provisioned to both nonprod and prod any region
  name        = "wsjapac-default-sg"
  description = "wsjapac-default-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    var.default_tags,
    {
      Name      = "wsjapac-default-sg"
      component = "sharsvc"
      preserve  = true
      ticket    = "AN-709"
    }
  )

  // SSH Inbound Access
  ingress {
    description = "SSH Access from Global Protect Subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = module.addresses.all_global_protect
  }

  // RDP Inbound Access
  ingress {
    description = "RDP from Global Protect Subnet"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = module.addresses.all_global_protect
  }

  // ICMP Inbound
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = module.addresses.all_internal
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
    cidr_blocks = module.dj_sg_addresses.smtp
  }

  // NTP TCP
  egress {
    description = "NTP TCP"
    from_port   = "123"
    to_port     = "123"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // NTP UDP
  egress {
    description = "NTP UDP"
    from_port   = "123"
    to_port     = "123"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // ICMP
  egress {
    description = "ICMP oubound all internal "
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = module.addresses.all_internal
  }

}
