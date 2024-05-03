locals {
  default_tags_aws_wsja_qa = {
    bu          = "djcs"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djcs/wsj/web"
    appid       = "djcs_wsj_web_wsja"
    ticket      = "AN-648"
    created_by  = "aws-cloudops@dowjones.com"
  }

  aws_wsja_qa_server_names = ["AWS-WSJA01-qa", "AWS-WSJA02-qa"]
  aws_wsja_qa_server_az_suffix_by_name = {
    AWS-WSJA01-qa = "a"
    AWS-WSJA02-qa = "c"
  }

}

data "aws_ami" "aws_wsja_qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-amzn_linux-2023-dowjones-base-202311061151"]
  }
}

resource "aws_key_pair" "hkpc-secure-wsj-asia-qa-key" {
  key_name   = "hkpc-secure-wsj-asia-qa-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkpc-secure-wsj-asia-qa"
}

resource "aws_instance" "aws_wsja_qa" {
  for_each               = toset(local.aws_wsja_qa_server_names)
  ami                    = data.aws_ami.aws_wsja_qa.image_id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.hkpc-secure-wsj-asia-qa-key.id
  subnet_id              = data.aws_subnets.protected[local.aws_wsja_qa_server_az_suffix_by_name[each.key]].ids.0
  vpc_security_group_ids = [data.aws_security_group.b_selected["wsjapac-default-sg"].id, aws_security_group.wsja-sg.id]

  metadata_options {
    http_tokens = "required" // enable IMDSv2 required
  }

  root_block_device {
    volume_size = 400
    volume_type = "gp3"
    tags = merge(
      local.default_tags_aws_wsja_qa,
      {
        Name = "${each.key}-root"
      }
    )
  }

  tags = merge(
    local.default_tags_aws_wsja_qa,
    {
      Name     = each.key
      autosnap = "bkp=a"
      preserve = true
    }
  )
}
