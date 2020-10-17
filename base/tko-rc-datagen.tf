resource "aws_eip" "tko-rc-datagen-eip" {
  vpc = true
}

resource "aws_eip_association" "tko-rc-datagen-eip-assoc" {
  count		= 4
  instance_id   = element(aws_instance.tko-rc-datagen.*.id, count.index)
  allocation_id = element(aws_eip.tko-rc-datagen-eip.*.id, count.index)
}

resource "aws_key_pair" "tko_rc_datagen_key" {
  key_name   = "tko_rc_datagen_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== tko-rc-datagen"
}

data "aws_ami" "win_image" {
  owners   = ["528339170479"]  
  filter {
    name   = "name"
    values = ["amigo-windows-2012-dowjones-base-201911150909"]
  }
}

data "aws_security_group" "djif-default" {
    filter {
        name = "group-name"
        values = ["djif_default"] 
    }
}

resource "aws_instance" "tko-rc-datagen" {
    count		   = 4
    ami                    = "${data.aws_ami.win_image.image_id}"
    instance_type          = "${var.tko_rc_datagen_instance_type}"
    key_name               = "${aws_key_pair.tko_rc_datagen_key.id}" 
    subnet_id              = "${var.tko_rc_datagen_subnet_id}" 
    vpc_security_group_ids = ["${data.aws_security_group.djif-default.id}"]

    root_block_device {
        volume_size = "${var.root_v_size}"
        volume_type = "${var.root_v_type}"
    }

    tags = {
        Name        = "${var.tko_rc_datagen_name}${count.index + 1}" 
        bu          = "${var.TagBU}"
        owner       = "${var.TagOwner}"
        environment = "${var.TagEnv}"
        product     = "${var.TagProduct}"
        component   = "${var.TagComponent}"
        servicename = "${var.TagServiceName}"
        appid       = "${var.appid}"       
    }
}
