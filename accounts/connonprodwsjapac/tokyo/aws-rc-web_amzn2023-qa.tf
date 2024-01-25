resource "aws_instance" "aws_rc_web_amzn2023" {
  for_each = {
    AWS-RC-WEB-11-QA = "a" // serverName = "AZ_short_id"
    AWS-RC-WEB-12-QA = "c"
  }
  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.aws_wsjasia_key_qa.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [aws_security_group.aws-rc-web-sg.id]

  root_block_device {
    volume_size           = 200
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false

    tags = merge(
      local.default_tags_rc_web,
      {
        Name   = "${each.key}-root"
        ticket = "CT-15762"
      }
    )
  }

  tags = merge(
    local.default_tags_rc_web,
    {
      Name     = each.key
      autosnap = "bkp=a"
      preserve = true
      ticket   = "CT-15762"
    }
  )
}
