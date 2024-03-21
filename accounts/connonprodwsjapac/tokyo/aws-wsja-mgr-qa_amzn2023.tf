resource "aws_instance" "wsja_mgr_amzn2023" {
  for_each = {
    tokqkwsjamgr01 = "a" // serverName = "AZ_short_id"
  }

  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.aws_wsjasia_key_qa.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [data.aws_security_group.b_selected["wsjapac-default-sg"].id, aws_security_group.wsja-mgr-sg.id]

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
      local.default_tags,
      {
        Name         = "${each.key}-root"
        appid        = "djcs_wsj_web_wsja"
        bu           = "djcs"
        servicename  = "djcs/wsj/web"
        preserve     = "true"
        ticket       = "AN-745"
      }
    )
  }

  tags = merge(
    local.default_tags,
    {
      Name         = each.key
      appid        = "djcs_wsj_web_wsja"
      bu           = "djcs"
      servicename  = "djcs/wsj/web"
      autosnap     = "bkp=a"
      preserve     = true
      ticket       = "AN-745"
    }
  )
}
