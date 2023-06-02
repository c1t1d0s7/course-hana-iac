packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
source "amazon-ebs" "linux" {
  #access_key = "AKIAXXX"
  #secret_key = "bbyBXXX"
  region        = "ap-northeast-2"
  profile       = "default"

  ami_name      = "mylinux"
  instance_type = "t2.micro"

  source_ami_filter {
    filters = {
      name                = var.image_filter
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = var.ssh_account
  #force_deregister = true
}

build {
  name = "my-ubuntu-web"
  sources = [
    "source.amazon-ebs.linux"
  ]

  provisioner "ansible" {
    playbook_file = "./web_install.yaml"
    extra_arguments = [
      "--become",
    ]
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]
  }
}
