// CT-14851
// data lookup and resources are queried from hkpc-cln-dist-qa

data "aws_ami" "hkpc-cln-dist01-qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202304191908"]
  }
}

resource "aws_instance" "hkpc-cln-dist01-qa" {
  ami                    = data.aws_ami.hkpc-cln-dist01-qa.image_id
  //instance_type          = var.instance_type
  instance_type          = "t3.xlarge"
  key_name               = aws_key_pair.hkpc-cln-dist-key.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-cln-dist.id, aws_security_group.hkpc-cln-dist.id, data.aws_security_group.djif-infrastructure-tools.id]

  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
    tags = {
      Name        = "cln-dist01-qa-root"
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
    Name        = "cln-dist01-qa"
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
