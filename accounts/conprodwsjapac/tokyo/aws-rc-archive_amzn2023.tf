locals {
  rc_archive_amzn2023_servers_by_name = {
    AWS-RC-Archive-11 = {
      az_short_id = "a"
      ticket      = "CT-15763"
    }
    AWS-RC-Archive-12 = {
      az_short_id = "c"
      ticket      = "CT-15763"
    }
  }

}

resource "aws_instance" "rc_archive_amzn2023" {
  for_each = local.rc_archive_amzn2023_servers_by_name

  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = "t3.xlarge"
  key_name               = data.aws_key_pair.wsj-tko-migration_key.id
  subnet_id              = data.aws_subnets.protected[each.value["az_short_id"]].ids.0
  vpc_security_group_ids = [data.aws_security_group.djif-default-fi.id, data.aws_security_group.AWS-RC-Archive-sg.id]

  root_block_device {
    volume_size = 300
    volume_type = "gp3"
    encrypted   = true

    tags = merge(
      local.default_tags_rc_archive,
      {
        Name   = "${each.key}-root"
        ticket = each.value["ticket"]
      }
    )
  }

  tags = merge(
    local.default_tags_rc_archive,
    {
      Name     = each.key
      autosnap = "bkp=a"
      preserve = true
      ticket   = each.value["ticket"]
    }
  )
}

resource "aws_ebs_volume" "rc_archive_amzn2023_sdf" {
  for_each = local.rc_archive_amzn2023_servers_by_name

  availability_zone = format("%s%s", data.aws_region.current.id, each.value["az_short_id"])
  type              = "gp3"
  size              = 600

  tags = merge(
    local.default_tags_rc_archive,
    {
      Name   = "${each.key}-sdf"
      ticket = each.value["ticket"]
    }
  )
}

resource "aws_volume_attachment" "rc_archive_amzn2023_sdf" {
  for_each = local.rc_archive_amzn2023_servers_by_name

  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.rc_archive_amzn2023_sdf[each.key].id
  instance_id = aws_instance.rc_archive_amzn2023[each.key].id
}
