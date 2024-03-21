resource "aws_security_group" "mob-app-sg" {
  name        = "mob-app-sg"
  description = "mob-app-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags,
    {
      Name         = "mob-app-sg"
      appid        = "djcs_wsj_backend_cwsjsupport"
      bu           = "djcs"
      servicename  = "djcs/wsj/web"
      preserve     = "true"
      ticket       = "AN-745"
    }
  )

  ingress {
    description = "SSH access from HKG Office subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.32.5.0/24"]
  }

  // ICMP Inbound
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // ICMP
  egress {
    description = "ICMP oubound all internet "
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
