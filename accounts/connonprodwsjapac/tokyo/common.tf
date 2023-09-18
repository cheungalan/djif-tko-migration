// NCTCOMPUTE-3245
data "aws_security_group" "djif-infrastructure-tools" {
  filter {
    name   = "group-name"
    values = ["djif_infrastructure_tools"]
  }
}