resource "aws_instance" "aws_rnc_web_amzn2023" {
  for_each = {
    tokqkrncweb01 = "a" // serverName = "AZ_short_id"
    tokqkrncweb02 = "c"
  }
  ami                    = data.aws_ami.amigo_amzn_linux2023.image_id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.aws_wsjasia_key_qa.id
  subnet_id              = data.aws_subnets.protected[each.value].ids.0
  vpc_security_group_ids = [data.aws_security_group.b_selected["wsjapac-default-sg"].id, aws_security_group.aws-rnc-web-sg.id]

  metadata_options { // required IMDSV2
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  root_block_device {
    volume_size           = 200
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false

    tags = merge(
      local.default_tags_rnc_web,
      {
        Name   = "${each.key}-root"
        ticket = "CT-15762"
      }
    )
  }

  tags = merge(
    local.default_tags_rnc_web,
    {
      Name     = each.key
      autosnap = "bkp=a"
      preserve = true
      ticket   = "CT-15762"
    }
  )
}
