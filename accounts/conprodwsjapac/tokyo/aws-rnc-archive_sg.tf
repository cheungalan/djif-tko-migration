resource "aws_security_group" "rnc-archive-sg" {
  name        = "rnc-archive-sg"
  description = "rnc-archive-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags_rnc_archive,
    {
      Name   = "rnc-archive-sg"
      ticket = "CT-15847"
    }
  )

  // Allow rDS access 
  egress {
    description     = "Access to RDS djcs-wsja-rds-prod.cluster-c1qsnfwzpreu.ap-northeast-1.rds.amazonaws.com"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [data.aws_security_group.wsj_prod_db.id]
  }

  // SSH access to tko-rc-web 
  egress {
    description     = "SSH access to tko-rc-web"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-06e24f4c64f2dad71"]
  }

  // SSH access to tko-rc-web 
  egress {
    description     = "SSH outbound access to tokpkrncweb"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.rnc-web-sg.id]
  }

}
