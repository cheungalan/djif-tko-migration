resource "aws_eip" "hkg-financial-inclusion-eip" {
  count = 1 
  vpc  = true
}

resource "aws_eip_association" "hkg-financial-inclusion-eip-assoc" {
  count		= 1 
  instance_id   = element(aws_instance.hkg-financial-inclusion.*.id, count.index)
  allocation_id = element(aws_eip.hkg-financial-inclusion-eip.*.id, count.index)
}

resource "aws_key_pair" "hkg_financial_inclusion_key" {
  key_name   = "hkg_financial_inclusion_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkg-financial-inclusion"
}

data "aws_ami" "hkg_financial_inclusion_image" {
  owners   = ["528339170479"]  
  filter {
    name   = "name"
    values = ["amigo-centos-7-dowjones-base-202010190921"]
  }
}

data "aws_security_group" "djif-default-fi" {
    filter {
        name = "group-name"
        values = ["djif_default"] 
    }
}

resource "aws_security_group" "djif-financial-sg" {
  name        = "djif-financial-sg"
  description = "djif-financial-sg"

  vpc_id      = var.vpc_id

  //IP-6495

  // Web Access 80
  ingress {
    description = "Web Access 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Web Access 443
  ingress {
    description = "Web Access 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH Access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.197.242.0/23", "10.197.244.0/23", "10.169.146.0/23", "10.169.148.0/23", "113.43.214.99/32", "205.203.99.34/32", "205.203.99.41/32", "203.116.229.70/32", "202.106.222.158/32", "10.140.16.0/20", "10.32.120.0/24"]
  }

  // ICMP 
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // SMTP
  egress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  // ICMP 
  egress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  // Internet Access 80
  egress {
    description = "Internet Access 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Internet Access 443
  egress {
    description = "Internet Access 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  // Allow rDS access 
  egress {
    description = "Access to RDS djcs-wsja-rds-prod.cluster-c1qsnfwzpreu.ap-northeast-1.rds.amazonaws.com"
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    security_groups = ["${data.aws_security_group.wsj_prod_db.id}"]
  }
  
  tags = {
    preserve = "true"
  }

}

/*
resource "aws_security_group_rule" "allow_rds_fin_egress" {
    description = "Access to RDS"
    security_group_id        = "${aws_security_group.djif-financial-sg.id}"
    type                     = "egress"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    source_security_group_id = data.aws_security_group.wsj_prod_db.id
}
*/

resource "aws_instance" "hkg-financial-inclusion" {
    count		   = 1 
    ami                    = "${data.aws_ami.hkg_financial_inclusion_image.image_id}"
    instance_type          = "${var.hkg_financial_inclusion_instance_type}"
    key_name               = "${aws_key_pair.hkg_financial_inclusion_key.id}" 
    subnet_id              = "${var.hkg_financial_inclusion_subnet_id}" 
    vpc_security_group_ids = ["${data.aws_security_group.djif-default-fi.id}","${aws_security_group.djif-financial-sg.id}"]

    root_block_device {
        volume_size = "${var.root_v_size}"
        volume_type = "${var.root_v_type}"
    }

    tags = {
        Name        = "${var.hkg_financial_inclusion_name}${count.index + 1}" 
        bu          = "${var.TagBU}"
        owner       = "${var.TagOwner}"
        environment = "${var.TagEnv}"
        product     = "${var.TagProduct}"
        component   = "${var.TagComponent}"
        servicename = "${var.TagServiceName}"
        appid       = "djcs_wsj_web_financialasia"       
        preserve    = true
    }
}
