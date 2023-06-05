// CT-14851
// data lookup and resources are queried from hkpc-jls-wrfeed

data "aws_ami" "hkpc-jls-wrfeed04-qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202304191908"]
  }
}

resource "aws_instance" "hkpc-jls-wrfeed4-qa" {
  ami                    = data.aws_ami.hkpc-jls-wrfeed04-qa.image_id
  instance_type          = var.instance_type
  key_name               = "hkpc-jls-wrfeed-key"
  subnet_id              = "subnet-076c0f9457edadfc9"
  vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-jls-wrfeed.id, aws_security_group.hkpc-jls-wrfeed.id]


  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
  }

  tags = {
    Name        = "jls-wrfeed04-qa"
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
