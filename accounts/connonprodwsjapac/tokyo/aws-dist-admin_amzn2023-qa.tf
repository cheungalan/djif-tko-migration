resource "aws_instance" "dist_admin_amzn2023" {
  for_each = {
    AWS-DIST-ADMIN-11-QA = "a" // serverName = "AZ_short_id"
  }

  ami                    = data.aws_ami.amigo_amzn_2023_image.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.hkpc-dist-admin-qa-key.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [aws_security_group.hkpc-dist-admin-qa.id]

  root_block_device {
    volume_size = 200
    volume_type = "gp3"
    encrypted   = true

    tags = merge(
      local.default_tags_dist_admin,
      {
        Name   = "${each.key}-root"
        ticket = "CT-15762"
      }
    )
  }

  tags = merge(
    local.default_tags_dist_admin,
    {
      Name     = each.key
      autosnap = "bkp=a"
      preserve = true
      ticket   = "CT-15762"
    }
  )
}

