resource "aws_instance" "cas_web_amzn2003" {
  for_each = {
    tokpkcasweb01 = "a" // serverName = "AZ_short_id"
    tokpkcasweb02 = "c"
  }

  ami           = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.aws_wsjasia_key.id
  subnet_id     = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [
    data.aws_security_group.b_selected["djif_default"].id,
    data.aws_security_group.b_selected["wsjapac-default-sg"].id,
    data.aws_security_group.b_selected["AWS-CAS-Web-sg"].id
  ]

  metadata_options { // required IMDSV2
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }


  root_block_device {
    volume_size = 300
    volume_type = "gp3"
    encrypted   = true

    tags = merge(
      local.default_tags_cas_web,
      {
        Name   = "${each.key}-root"
        ticket = "CT-15763"
      }
    )
  }

  tags = merge(
    local.default_tags_cas_web,
    {
      Name     = each.key
      autosnap = "bkp=o" // 14:00 - 14:59 UTC
      ticket   = "CT-15763"
      preserve = true
    }
  )
}
