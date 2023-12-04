locals {
  default_tags_aws_wsja_qa = {
    bu          = "djcs"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djcs/wsj/web"
    appid       = "djcs_wsj_web_securewsja"
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

resource "aws_instance" "aws_wsja_qa" {
  for_each               = toset(local.aws_wsja_qa_server_names)
  ami                    = data.aws_ami.aws_wsja_qa.image_id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.hkpc-secure-wsj-asia-qa-key.id
  subnet_id              = data.aws_subnets.protected[local.aws_wsja_qa_server_az_suffix_by_name[each.key]].ids.0
  vpc_security_group_ids = [aws_security_group.hkpc-secure-wsj-asia-qa.id]
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
