resource "aws_key_pair" "hkpk-newsnet-qa-key" {
  key_name   = "hkpk-newsnet-qa-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkpk-newsnet-qa"
}

resource "aws_security_group" "hkpk-newsnet-qa" {
  name        = "hkpk-newsnet-qa"
  description = "hkpk-newsnet-qa"
  vpc_id      =  var.vpc_id 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8","172.26.0.0/16","192.168.0.0/16"]
  }

  ingress {
    from_port   = 80 
    to_port     = 80 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8","172.26.0.0/16","192.168.0.0/16"]
  }

  ingress {
    from_port   = 443 
    to_port     = 443 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8","172.26.0.0/16","192.168.0.0/16"]
  }

  ingress {
    from_port   = 3306 
    to_port     = 3306 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = -1 
    to_port     = -1 
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 21
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["162.0.0.0/8"]
  }
  
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["162.0.0.0/8"]
  }
  
  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  } 
  
  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }  
  
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    preserve = "true"
  }
}

data "aws_ami" "hkpk-newsnet-qa" {
  owners   = ["528339170479"]  
  filter {
    name   = "name"
    values = ["amigo-centos-7-dowjones-base-202010190921"]
  }
}

resource "aws_instance" "hkpk-newsnet-qa" {
    count		   = 1 
    ami                    = "${data.aws_ami.hkpk-newsnet-qa.image_id}"
    instance_type          = "${var.instance_type}"
    key_name               = "${aws_key_pair.hkpk-newsnet-qa-key.id}" 
    subnet_id              = "${var.subnet_id}" 
    vpc_security_group_ids = ["${aws_security_group.hkpk-newsnet-qa.id}"]

    root_block_device {
        volume_size = "${var.root_v_size}"
        volume_type = "${var.root_v_type}"
    }

    tags = {
        Name        = "${var.hkpk-newsnet-qa-name}${count.index + 1}" 
        bu          = "djcs"
        owner       = "${var.TagOwner}"
        environment = "${var.TagEnv}"
        product     = "${var.TagProduct}"
        component   = "${var.TagComponent}"
        servicename = "djcs/wsj/web"
        appid       = "${var.appid}"       
        preserve    = true
    }
}
