resource "aws_security_group" "cas-web-sg" {
  name        = "cas-web-sg"
  description = "cas-web-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_cas_web,
    {
      Name     = "cas-web-sg"
      ticket   = "CT-15847"
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

  // RDS TCP
  egress {
    description     = "Access to RDS djcs-wsja-rds-prod.cluster-c1qsnfwzpreu.ap-northeast-1.rds.amazonaws.com"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-08e66e35c6eacb656"]
  }

}
