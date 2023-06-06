// CT-14851
// data lookup and resources are queried from hkpc-cwsj-ftp-gateway

data "aws_ami" "hkpc-cwsj-ftp01-gateway-qa" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-windows-2019-dowjones-base-202304191908"]
  }
}

resource "aws_instance" "hkpc-cwsj-ftp01-gateway-qa" {
  ami                    = data.aws_ami.hkpc-cwsj-ftp01-gateway-qa.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.hkpc-cwsj-ftp-gateway-key.id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.djif-default-hkpc-cwsj-ftp-gateway.id, aws_security_group.hkpc-cwsj-ftp-gateway.id]

  root_block_device {
    volume_size = var.root_v_size
    volume_type = var.root_v_type
    tags = {
      Name        = "cwsj-ftp01-qa-root"
      bu          = "djcs"
      owner       = var.TagOwner
      environment = var.TagEnv
      product     = "wsj"
      component   = var.TagComponent
      servicename = "djcs/wsj/web"
      appid       = "djcs_wsj_backend_cwsjsupport"
    }
  }

  tags = {
    Name        = "cwsj-ftp01-qa"
    bu          = "djcs"
    owner       = var.TagOwner
    environment = var.TagEnv
    product     = "wsj"
    component   = var.TagComponent
    servicename = "djcs/wsj/web"
    appid       = "djcs_wsj_backend_cwsjsupport"
    autosnap    = "bkp=a"
    preserve    = true
  }
}
