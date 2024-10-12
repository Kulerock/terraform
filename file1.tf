provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "eu-north-1"
}

resource "aws_instance" "terraform_lesson" {
  ami           = "ami-097c5c21a18dc59ea"
  instance_type = "t3.micro"

  tags = {
    Name    = "1st_instance"
    Owner   = "kulerock"
    Project = "Terraform Lessons"
  }
}