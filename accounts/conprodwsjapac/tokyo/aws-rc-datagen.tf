// CT-15538
/*
resource "aws_eip" "aws-rc-datagen-eip" {
  count  = 4
  domain = "vpc"
}

resource "aws_eip_association" "aws-rc-datagen-eip-assoc" {
  count         = 4
  instance_id   = element(aws_instance.aws-rc-datagen.*.id, count.index)
  allocation_id = element(aws_eip.aws-rc-datagen-eip.*.id, count.index)
}
*/

resource "aws_key_pair" "aws_rc_datagen_key" {
  key_name   = "aws_rc_datagen_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== aws-rc-datagen"
}


resource "aws_volume_attachment" "aws-rc-datagen" {
  count       = 4
  device_name = "/dev/sdf"
  volume_id   = element(aws_ebs_volume.aws-rc-datagen.*.id, count.index)
  instance_id = element(aws_instance.aws-rc-datagen.*.id, count.index)
}

resource "aws_ebs_volume" "aws-rc-datagen" {
  count             = 4
  availability_zone = aws_instance.aws-rc-datagen[count.index].availability_zone

  type              = "gp3"
  size              = 300

  tags = {
    Name        = "${var.aws_rc_datagen_name}${count.index + 1}/dev/sdf"
    bu          = var.TagBU
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = var.TagServiceName
    appid       = "in_platform_randc_datagenjapan"
    autosnap    = "bkp=g"
  }

}

resource "aws_instance" "aws-rc-datagen" {
  count                  = 4
  ami                    = data.aws_ami.win_image.image_id
  instance_type          = var.aws_rc_datagen_instance_type
  key_name               = aws_key_pair.aws_rc_datagen_key.id
  subnet_id              = var.aws_rc_datagen_subnet_id
  vpc_security_group_ids = [data.aws_security_group.djif-default-datagen.id, aws_security_group.djif-datagen-sg.id]
  availability_zone      = element(["ap-northeast-1a", "ap-northeast-1c"], count.index % 2)

  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
    tags = {
      Name        = "${var.aws_rc_datagen_name}${count.index + 1}-root"
      bu          = var.TagBU
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = var.TagProduct
      component   = var.TagComponent
      servicename = var.TagServiceName
      appid       = "in_platform_randc_datagenjapan"
    }
  }

  tags = {
    Name        = "${var.aws_rc_datagen_name}${count.index + 1}"
    bu          = var.TagBU
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = var.TagServiceName
    appid       = "in_platform_randc_datagenjapan"
    preserve    = true
    autosnap    = "bkp=o"
  }
}

