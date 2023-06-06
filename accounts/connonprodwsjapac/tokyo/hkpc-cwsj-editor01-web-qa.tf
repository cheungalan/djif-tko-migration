// CT-14851
// data lookup and resources are queried from hkpc-cwsj-editor-web

data "aws_ami" "hkpc-cwsj-editor01-web-qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202304191908"]
  }
}

resource "aws_instance" "hkpc-cwsj-editor01-web-qa" {
  ami                    = data.aws_ami.hkpc-cwsj-editor01-web-qa.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.hkpc-cwsj-editor-web-key.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-cwsj-editor-web.id, aws_security_group.hkpc-cwsj-editor-web.id]

  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
    tags = {
      Name        = "cwsj-editor01-qa-root"
      bu          = "djcs"
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = var.TagProduct
      component   = var.TagComponent
      servicename = "djcs/wsj/web"
      appid       = "djcs_edttools_web_cwsjediting"
    }
  }

  tags = {
    Name        = "cwsj-editor01-qa"
    bu          = "djcs"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djcs/wsj/web"
    appid       = "djcs_edttools_web_cwsjediting"
    autosnap    = "bkp=a"
    preserve    = true
  }
}
