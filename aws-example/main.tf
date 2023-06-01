# https://registry.terraform.io/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-092dfb48456a3b119"
  instance_type = "t2.micro"
  #instance_type = "t3.micro"

  tags = {
    Name = "MyInstance"
  }
}
