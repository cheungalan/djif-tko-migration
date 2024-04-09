resource "aws_security_group" "jwr-web-sg" {
  name        = "jwr-web-sg"
  description = "jwr-web-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_jwr_web,
    {
      Name   = "jwr-web-sg"
      ticket = "CT-15847"
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

  // 3306 Access AWS-JLS-Feed-sg
  ingress {
    description     = "MySQL Access from AWS-JLS-Feed-sg"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-0bf184f21f20d632d"]
  }

  // 3306 Self inbound Access  
  ingress {
    description = "MySQL self inbound Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = true
  }

  // 3306 Self Outbound Access
  egress {
    description = "MySQL self outbound Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = true
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
