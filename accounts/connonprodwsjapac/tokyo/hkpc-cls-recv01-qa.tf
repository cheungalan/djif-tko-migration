// CT-14851
// data lookup and resources are queried from hkpc-cls-recv-qa

data "aws_ami" "hkpc-cls-recv01-qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202304191908"]
  }
}

resource "aws_instance" "hkpc-cls-recv01-qa" {
  ami                    = data.aws_ami.hkpc-cls-recv01-qa.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.hkpc-cls-recv-key.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-cls-recv.id, aws_security_group.hkpc-cls-recv.id]


  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
    tags = {
      Name        = "cls-receiver01-qa"
      bu          = "djin"
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = var.TagProduct
      component   = var.TagComponent
      servicename = "djin/newswires/web"
      appid       = "in_newswires_djnews_clsdist"
    }
  }

  tags = {
    Name        = "cls-receiver01-qa"
    bu          = "djin"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = var.TagProduct
    component   = var.TagComponent
    servicename = "djin/newswires/web"
    appid       = "in_newswires_djnews_clsdist"
    autosnap    = "bkp=a"
    preserve    = true
  }
}
