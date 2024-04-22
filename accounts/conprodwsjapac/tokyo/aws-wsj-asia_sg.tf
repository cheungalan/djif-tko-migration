resource "aws_security_group" "wsj-asia-sg" {
  name        = "wsj-asia-sg"
  description = "wsj-asia-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_wsj_asia,
    {
      Name     = "wsj-asia-sg"
      ticket   = "AN-796"
    }
  )

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
    cidr_blocks = ["10.0.0.0/8"]
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
