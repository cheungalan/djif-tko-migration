resource "aws_eip" "hkg-jwsj-archive-eip" {
  count = 2 
  vpc  = true
}

resource "aws_eip_association" "hkg-jwsj-archive-eip-assoc" {
  count		= 2 
  instance_id   = element(aws_instance.hkg-jwsj-archive.*.id, count.index)
  allocation_id = element(aws_eip.hkg-jwsj-archive-eip.*.id, count.index)
}

resource "aws_key_pair" "hkg_jswj_archive_key" {
  key_name   = "hkg_jswj_archive_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkg-jwsj-archive"
}

data "aws_ami" "hkg_jswj_archive_image" {
  owners   = ["528339170479"]  
  filter {
    name   = "name"
    values = ["amigo-centos-7-dowjones-base-202010190921"]
  }
}

data "aws_security_group" "djif-default-archive" {
    filter {
        name = "group-name"
        values = ["djif_default"] 
    }
}

resource "aws_instance" "hkg-jwsj-archive" {
    count		   = 2 
    ami                    = "${data.aws_ami.hkg_jswj_archive_image.image_id}"
    instance_type          = "${var.hkg_jswj_archive_instance_type}"
    key_name               = "${aws_key_pair.hkg_jswj_archive_key.id}" 
    subnet_id              = "${var.hkg_jswj_archive_subnet_id}" 
    vpc_security_group_ids = ["${data.aws_security_group.djif-default-archive.id}"]

    root_block_device {
        volume_size = "${var.root_v_size}"
        volume_type = "${var.root_v_type}"
    }

    tags = {
        Name        = "${var.hkg_jswj_archive_name}${count.index + 1}" 
        bu          = "${var.TagBU}"
        owner       = "${var.TagOwner}"
        environment = "${var.TagEnv}"
        product     = "${var.TagProduct}"
        component   = "${var.TagComponent}"
        servicename = "${var.TagServiceName}"
        appid       = "${var.appid}"       
        preserve    = true
    }
}
