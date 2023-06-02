variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "ami_image" {
  description = "Ubuntu 20.04 LTS Image"
  type        = map(string)
  default = {
    ap-northeast-1 = "ami-079c663c50413a220"
    ap-northeast-2 = "ami-048299d2b7b438e05"
  }
}
# var.ami_image["ap-northeast-2"] ==> ami-048299d2b7b438e05

#variable "fruit_list" {
#  tpye = list(string)
#  default = [
#    "apple",
#    "banana"
#  ]
#}
# var.fruit_list[0] ==> apple

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my_project"
}

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}
