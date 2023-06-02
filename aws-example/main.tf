resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu_focal.id
  instance_type = var.instance_type

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

resource "aws_eip" "my_eip" {
  vpc      = true
  instance = aws_instance.my_instance.id

  tags = local.common_tags
}
