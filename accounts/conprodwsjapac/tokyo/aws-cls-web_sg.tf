resource "aws_security_group" "cls-web-sg" {
  name        = "cls-web-sg"
  description = "cls-web-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_cls_web,
    {
      Name     = "cls-web-sg"
      preserve = true
      ticket   = "CT-15847"
    }
  )

  // Web Access 80
  ingress {
    description = "Web Access 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Web Access 443
  ingress {
    description = "Web Access 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SFTP Access from AWS-CLS-LLS
  ingress {
    description     = "SFTP Access from AWS-CLS-LLS"
    from_port       = 22 
    to_port         = 22 
    protocol        = "tcp"
    security_groups = ["sg-0e2b9844b5b0c97b5"]
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
