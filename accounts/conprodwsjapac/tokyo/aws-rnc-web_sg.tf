resource "aws_security_group" "rnc-web-sg" {
  name        = "rnc-web-sg"
  description = "rnc-web-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_rnc_web,
    {
      Name   = "rnc-web-sg"
      ticket = "CT-15847"
    }
  )

  ingress {
    description = "HTTP access from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH Access
  ingress {
    description     = "SSH Access from AWS-RC-ARCHIVE"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-0fa18ad2d052a29e1"]
  }

  ingress {
    description     = "FTP Access from AWS-RC-DATAGEN"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-05132d98a2237dc55"]
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
