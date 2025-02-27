/*
resource "aws_key_pair" "hkpc-cwsj-sql-key" {
  key_name   = "hkpc-cwsj-sql-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvFIrPz7DNwnVVl3XKd6trWoaRhIpo4xLYQO9G00PmWkRpssDZuDGwEeyVnGkV2R3h56ojIcQxeRa74s16+Drpu6Gf8OcbQvI0M+Z1EGVCd+R/DMxBfNGBJt33t1FIAh+xnqF5XxFdqvGpHKeLsHAEZs7zNAZHO09g6OSL5ivisjGIpOqyL3W2NGljj2ihYTYP3lr5TG52Gw5jpbXEtHTP+KHODfZxh79shFbo/q5aD11rU3sgMTO4jQIks0R5e4nzLcajG3kBVqcFfLX68cyT4ZWMQ4h21rdmUmgC2ZtNcMMtigANRvV86wCDcA3MgfJnnH+Eq9brGf+wZvlIfpxv6rTk9FisRx3ikBQNWNLvFYw+pHKLR61UWKBwoAUx1NRcdH/8qpjroyWADIVAffNcOXADSONuEep3b2ZWQatYoj6ZNDnTuOnC7qfm2hMtFN5/YzRyAaOVr6x91/fgwXMDJruq/8UMY08u4TEbmmN52gtlIo3rx9LQ7nh5lLTsoLQOufLe5n10BqYxQzbLOjyY1YeR8cuqNj5yAiTOPXfeAdDhztieWbj0Gt86DedNZOLvy7/b0XdErVYFhVjltjLpQMB4k4cvndYOWXbcMjPyGGkUtQXgmaThy5I05mZuDNdhEn7XWmBvc7iqS50rPl8Zhqi404NqV4zr0E2S3D1J5Q== hkpc-cwsj-sql"
}

data "aws_security_group" "djif-default-hkpc-cwsj-sql" {
    filter {
        name = "group-name"
        values = ["djif_default"]
    }
}

data "aws_security_group" "djif-cyberark-mssql-hkpc-cwsj-sql" {
    filter {
        name = "group-name"
        values = ["djif_cyberark_mssql"]
    }
}

resource "aws_security_group" "hkpc-cwsj-sql" {
  name        = "hkpc-cwsj-sql"
  description = "hkpc-cwsj-sql"
  vpc_id      =  var.vpc_id 

  ingress {
    from_port   = 3389 
    to_port     = 3389 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8","172.26.0.0/16","192.168.0.0/16"]
  }

  ingress {
    from_port   = 21 
    to_port     = 21 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 139 
    to_port     = 139 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 445 
    to_port     = 445 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 1433 
    to_port     = 1433 
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
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 1433 
    to_port     = 1433 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 445 
    to_port     = 445 
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    preserve = "true"
  }
}

resource "aws_volume_attachment" "ebs_hkpc-cwsj-sql" {
    device_name = "/dev/sdf"
    volume_id   = aws_ebs_volume.hkpc-cwsj-sql.id
    instance_id = aws_instance.hkpc-cwsj-sql.id
}

resource "aws_ebs_volume" "hkpc-cwsj-sql" {
    availability_zone = aws_instance.hkpc-cwsj-sql.availability_zone
    type              = "gp3"
    size              = 1600 
  
    tags = {
      Name        = var.hkpc-cwsj-sql-name
      bu          = var.TagBU
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = var.TagProduct
      component   = var.TagComponent
      servicename = var.TagServiceName
      appid       = "djcs_edttools_web_cwsjediting"      
    }    
    lifecycle {
     ignore_changes = all
    }   
}

data "aws_ami" "hkpc-cwsj-sql" {
  owners   = ["534664863199"]  
  filter {
    name   = "name"
    values = ["DJW2K16DC-Vanilla-SQL2017_20180927"]
  }
}

resource "aws_instance" "hkpc-cwsj-sql" {
    ami                    = data.aws_ami.hkpc-cwsj-sql.image_id
    instance_type          = var.instance_type
    key_name               = aws_key_pair.hkpc-cwsj-sql-key.id
    subnet_id              = var.subnet_id
    vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-cwsj-sql.id, aws_security_group.hkpc-cwsj-sql.id, data.aws_security_group.djif-cyberark-mssql-hkpc-cwsj-sql.id]


    root_block_device {
        volume_size = var.root_v_size
        volume_type = var.root_v_type
    }
  
    lifecycle {
     ignore_changes = all
    }  

    tags = {
        Name        = var.hkpc-cwsj-sql-name
        bu          = var.TagBU
        owner       = var.TagOwner
        environment = var.TagEnv
        product     = var.TagProduct
        component   = var.TagComponent
        servicename = var.TagServiceName
        appid       = "djcs_edttools_web_cwsjediting"       
        preserve    = true
    }
}
*/
