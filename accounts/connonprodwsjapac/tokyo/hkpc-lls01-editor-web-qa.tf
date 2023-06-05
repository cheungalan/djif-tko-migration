data "aws_ami" "hkpc-lls01-editor-qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202304191908"]
  }
}

resource "aws_instance" "hkpc-lls01-editor-qa" {
  ami                    = data.aws_ami.hkpc-lls01-editor-qa.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.hkpc-lls-editor-web-key.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-lls-editor-web.id, aws_security_group.hkpc-lls-editor-web.id]


  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
  }

  tags = {
    Name        = "lls01-editor-qa"
    bu          = "djin"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djin/newswires/web"
    appid       = "in_newswires_web_lls"
    autosnap    = "bkp=a"
    preserve    = true
  }
}
