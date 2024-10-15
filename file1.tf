provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "terraform_lesson" {
  ami                    = "ami-097c5c21a18dc59ea"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.first_group.id]
  user_data              = templatefile("user_data.sh.tpl",{
    f_name               = "Kate",
    l_name               = "Kulikovich",
    names                = ["Vasya","Kolya","Petya","Masha"]
  })
  metadata_options {
    http_tokens = "optional"
  }

  tags = {
    Name    = "first_instance"
    Owner   = "kulerock"
    Project = "Terraform Lessons"
  }
}

resource "aws_security_group" "first_group" {
  name        = "Dynamic Security Group"
  description = "Allow SSH inbound traffic"
  
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "Dynamic Security Group"
  }
}