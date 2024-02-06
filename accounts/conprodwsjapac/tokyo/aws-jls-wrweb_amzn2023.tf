resource "aws_instance" "jls_wrweb_amzn2023" {
  for_each = {
    AWS-JLS-WRWEB-11 = "a" // serverName = "AZ_short_id"
    AWS-JLS-WRWEB-12 = "c"
  }

  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = "t3.xlarge"
  key_name               = aws_key_pair.aws_wsjasia_key.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [data.aws_security_group.b_selected["AWS-JLS-WRWEB-sg"].id]

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
      local.default_tags_jls_wrweb,
      {
        Name   = "${each.key}-root"
        ticket = "CT-15763"
      }
    )
  }

  tags = merge(
    local.default_tags_jls_wrweb,
    {
      Name     = each.key
      autosnap = "bkp=o"
      preserve = true
      ticket   = "CT-15763"
    }
  )
}
