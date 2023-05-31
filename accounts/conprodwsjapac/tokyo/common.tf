data "aws_security_group" "wsj_prod_db" {
  filter {
    name   = "group-name"
    values = ["djcs-prod-wsja_con-db-sg"]
  }
}
