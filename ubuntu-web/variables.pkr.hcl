variable "image_filter" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "ssh_account" {
  type    = string
  default = "ubuntu"
}