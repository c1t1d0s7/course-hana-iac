module "my_vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = var.vpc_name
  cidr               = var.vpc_cidr
  azs                = var.vpc_azs
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
  tags               = local.common_tags
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu_focal.id
  instance_type = var.instance_type

  #key_name               = aws_key_pair.my_sshkey.key_name
  subnet_id              = module.my_vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.my_sg_web.id]

  # 1. Heredoc
  #user_data = <<-EOF
  #  #!/bin/bash
  #  sudo apt update
  #  sudo apt install -y apache2
  #  sudo systemctl --now enable apache2
  #  echo "<h1> Hello World </h1>" | sudo tee /var/www/html/index.html
  #  EOF

  # 2. File Function
  user_data = file("./web_deploy.sh")

  tags = local.common_tags
}

#resource "aws_key_pair" "my_sshkey" {
#  key_name   = "my_sshkey"
#  public_key = file("./my_sshkey.pub")
#}
##> ssh-keygen -f "my_sshkey" -N ''

resource "aws_eip" "my_eip" {
  vpc      = true
  instance = aws_instance.my_instance.id

  tags = local.common_tags
}
