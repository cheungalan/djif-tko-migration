data "aws_security_group" "djif-default-hkpc-jls-wrfeed2" {
    filter {
        name = "group-name"
        values = ["djif_default"]
    }
}

data "aws_security_group" "hkpc-jls-wrfeed" {
    filter {
        name = "group-name"
        values = ["hkpc-jls-wrfeed"]
    }
}

data "aws_ami" "hkpc-jls-wrfeed2" {
  most_recent = true
  owners   = ["819633815198"]  
  filter {
    name   = "name"
    values = ["DJW2K19DC_VANILLA_PACKER_CHEF12*"]
  }
}

resource "aws_instance" "hkpc-jls-wrfeed2" {
    ami                    = "${data.aws_ami.hkpc-jls-wrfeed2.image_id}"
    instance_type          = "${var.instance_type}"
    key_name               = "hkpc-jls-wrfeed-key" 
    subnet_id              = "subnet-076c0f9457edadfc9" 
    vpc_security_group_ids = ["${data.aws_security_group.djif-default-hkpc-jls-wrfeed2.id}","${data.aws_security_group.hkpc-jls-wrfeed.id}"]


    root_block_device {
        volume_size = "${var.root_v_size}"
        volume_type = "${var.root_v_type}"
    }

    tags = {
        Name        = "jls-wrfeed02-qa" 
        bu          = "djin"
        owner       = "${var.TagOwner}"
        environment = "${var.TagEnv}"
        product     = "${var.TagProduct}"
        component   = "${var.TagComponent}"
        servicename = "djin/newswires/web"
        appid       = "in_newswires_web_jlswireryter"    
        autosnap    = "bkp=a"
        preserve    = true
    }
}
