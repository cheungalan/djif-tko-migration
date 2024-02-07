resource "aws_security_group" "cas_web-sg" {
  name        = "cas_web-sg"
  description = "cas_web-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_cas_web,
    {
      Name     = "cas-web-sg"
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

  egress {
    description     = "MySQL Access to RDS djcs-wsja-rds-qa.cluster-ckwswi0iistd.ap-northeast-1.rds.amazonaws.com"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-01536f4a5ec7e6519"]
  }

}
