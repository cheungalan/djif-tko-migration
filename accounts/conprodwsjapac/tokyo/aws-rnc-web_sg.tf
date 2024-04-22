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

  ingress {
    description     = "FTP Access from AWS-RC-DATAGEN"
    from_port       = 21
    to_port         = 21
    protocol        = "tcp"
    security_groups = ["sg-05132d98a2237dc55"]
  }

  // SSH Access
  ingress {
    description     = "SFTP Access from AWS-RC-DATAGEN"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-05132d98a2237dc55"]
  }

  // SSH Access
  ingress {
    description     = "SFTP inbound access from AWS-RC-ARCHIVE"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-0fa18ad2d052a29e1"]
  }

  // SSH Access
  ingress {
    description     = "SFTP inbound access from tokpkrncarchv"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-0c568e20a33221898"]
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
