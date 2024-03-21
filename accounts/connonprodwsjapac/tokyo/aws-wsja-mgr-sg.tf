resource "aws_security_group" "wsja-mgr-sg" {
  name        = "wsja-mgr-sg"
  description = "wsja-mgr-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags,
    {
      Name         = "wsja-mgr-sg"
      appid        = "djcs_wsj_web_wsja"
      bu           = "djcs"
      servicename  = "djcs/wsj/web"
      preserve     = "true"
      ticket       = "AN-745"
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
    description     = "SFTP access from cln-dist01-qa"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-0de67358259cbbc62"]
  }

  ingress {
    description     = "SFTP access from JLS-WRFEED-QA"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-0f27d915082a302b7"]
  }

  ingress {
    description     = "SFTP access from CAS_App01_QA"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["sg-02db8573b985e2d52"]
  }

  // Allow RDS access
  egress {
    description     = "Access to RDS djcs-wsja-rds-qa.cluster-ckwswi0iistd.ap-northeast-1.rds.amazonaws.com"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["sg-01536f4a5ec7e6519"]
  }

  // 4001
  egress {
    description     = "access to CWSJ Convertor (hkpc-cwsj-mobile-converter-qa1)"
    from_port       = 4001
    to_port         = 4001
    protocol        = "tcp"
    security_groups = ["sg-02d14f3a24629f322"]
  }

}
