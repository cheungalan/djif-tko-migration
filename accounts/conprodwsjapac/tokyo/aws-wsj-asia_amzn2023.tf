resource "aws_instance" "wsj_asia_amzn2023" {
  for_each = {
    tokpkwsjasia01 = "a" // serverName = "AZ_short_id"
    tokpkwsjasia02 = "c"
  }

  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = "t3.large"
  key_name               = aws_key_pair.aws_wsjasia_key.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [
    data.aws_security_group.b_selected["djif_default"].id,
    data.aws_security_group.b_selected["wsjapac-default-sg"].id,
    aws_security_group.wsj-asia-sg.id
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
      local.default_tags_wsj_asia,
      {
        Name   = "${each.key}-root"
        ticket = "AN-796"
      }
    )
  }

  tags = merge(
    local.default_tags_wsj_asia,
    {
      Name     = each.key
      autosnap = "bkp=o"
      preserve = true
      ticket   = "AN-796"
    }
  )
}
