data "aws_security_group" "hkpk-jls-wrweb1-qa" {
  filter {
    name   = "group-name"
    values = ["hkpk-jls-wrweb1-qa"]
  }
}

resource "aws_instance" "hkpk-jls-wrweb2-qa" {
  ami                    = "ami-0e35006f2980df05d"
  instance_type          = var.instance_type
  key_name               = "hkpk-jls-wrweb1-qa-key"
  subnet_id              = "subnet-076c0f9457edadfc9"
  vpc_security_group_ids = [data.aws_security_group.hkpk-jls-wrweb1-qa.id]

  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
  }

  tags = {
    Name        = "hkpk-jls-wrweb2-qa"
    bu          = "djin"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djin/newswires/web"
    appid       = "in_newswires_web_jlswireryter"
    autosnap    = "bkp=a"
    preserve    = true
  }
}
