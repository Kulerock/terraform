provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "terraform_lesson" {
  ami           = "ami-097c5c21a18dc59ea"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.first_group.id]
  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
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
  name        = "WebServer Security Group"
  description = "Allow SSH inbound traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}