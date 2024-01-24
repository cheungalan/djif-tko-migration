resource "aws_instance" "aws_rc_web_amzn2023" {
  for_each = {
    AWS-RC-WEB-11 = "a" // serverName = "AZ_short_id"
    AWS-RC-WEB-12 = "c"
  }

  ami                    = data.aws_ami.amigo_amzn_2023_image.image_id
  instance_type          = "t3.large"
  key_name               = aws_key_pair.tko_rc_web_key.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [data.aws_security_group.djif-default-web.id, aws_security_group.djif-rc-web-sg.id]

  root_block_device {
    volume_size           = 300
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false

    tags = merge(
      local.default_tags_rc_web,
      {
        Name = "${each.key}-root"
      }
    )
  }

  tags = merge(
    local.default_tags_rc_web,
    {
      Name     = each.key
      autosnap = "bkp=o"
      preserve = true
    }
  )
}
