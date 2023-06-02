resource "aws_instance" "my_instance_a" {
  ami           = "ami-048299d2b7b438e05"
  instance_type = "t2.micro"

  tags = {
    Name = "MyInstanceA"
  }
}

resource "aws_instance" "my_instance_b" {
  ami           = "ami-048299d2b7b438e05"
  instance_type = "t2.micro"

  tags = {
    Name = "MyInstanceB"
  }

  depends_on = [aws_s3_bucket.my_bucket]
}

resource "aws_eip" "my_eip" {
  vpc      = true
  instance = aws_instance.my_instance_a.id
}

resource "aws_s3_bucket" "my_bucket" {
  # name = "BUCKET_NAME"
}

#resource "aws_s3_bucket_acl" "my_bucket_acl" {
#  bucket = aws_s3_bucket.my_bucket.id
#  acl    = "private"
#}
