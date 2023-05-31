data "aws_caller_identity" "current" {
  # no arguments
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.deployment_role}"
  }
}
