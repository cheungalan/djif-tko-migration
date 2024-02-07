resource "aws_instance" "aws_cas_web_amzn2003" {
  for_each = {
    tokqkcasweb01 = "a" // serverName = "AZ_short_id"
  }

  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.aws_wsjasia_key_qa.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [data.aws_security_group.b_selected["wsjapac-default-sg"].id, data.aws_security_group.b_selected["djif_infrastructure_tools"].id, aws_security_group.cas-web-sg.id]

  metadata_options { // required IMDSV2
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  root_block_device {
    volume_size = 200
    volume_type = "gp3"
    encrypted   = true

    tags = merge(
      local.default_tags_cas_web,
      {
        Name   = "${each.key}-root"
        ticket = "CT-15762"
      }
    )
  }

  tags = merge(
    local.default_tags_cas_web,
    {
      Name     = each.key
      autosnap = "bkp=a" // 14:00 - 14:59 UTC
      ticket   = "CT-15762"
      preserve = true
    }
  )
}
