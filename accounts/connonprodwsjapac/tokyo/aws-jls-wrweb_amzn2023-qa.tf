resource "aws_instance" "jls_wrweb_amzn2023" {
  for_each = {
    AWS-JLS-WRWEB-11-QA = "a" // serverName = "AZ_short_id"
    AWS-JLS-WRWEB-12-QA = "c"
  }

  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.hkpk-jls-wrweb1-qa-key.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [aws_security_group.aws-jls-wrweb-sg.id]

  root_block_device {
    volume_size = 200
    volume_type = "gp3"
    encrypted   = true

    tags = merge(
      local.default_tags_jls_wrweb,
      {
        Name   = "${each.key}-root"
        ticket = "CT-15762"
      }
    )
  }

  tags = merge(
    local.default_tags_jls_wrweb,
    {
      Name     = each.key
      autosnap = "bkp=a"
      preserve = true
      ticket   = "CT-15762"
    }
  )
}
