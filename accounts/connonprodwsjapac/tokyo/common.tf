## common by environment 
data "aws_ami" "amigo_amzn_linux2023" {
  owners = ["528339170479"]
  filter {
    name   = "name"
    values = ["amigo-amzn_linux-2023-dowjones-base-202401042335"]
  }
}
