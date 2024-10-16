provider "aws" {
  region = "eu-north-1"
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "first_group" {
  name        = "Dynamic Security Group"
  description = "Allow SSH inbound traffic"
  
  dynamic "ingress" {
    for_each = ["80", "443"]
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

resource "aws_launch_configuration" "web" {
  name            = "WebServer-Highly-Available"
  image_id        = "ami-097c5c21a18dc59ea"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.first_group.id]
  user_data       = file("user_data.sh.tpl")
#   ,{
#      f_name               = "Kate",
#      l_name               = "Kulikovich",
#      names                = ["Vasya","Kolya","Petya","Masha"]
#    })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                      = "WebServer-Highly-Available-ASG"
  launch_configuration      = aws_launch_configuration.web.name
  max_size                  = 1
  min_size                  = 1
  min_elb_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier      = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers           = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
        Name   = "WebServer-in-ASG"
        Owner  = "Kate"
        TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true  
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.first_group.id]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  } 
    tags = {
      Name = "WebServer-Highly-Available-ELB"
  }
}

  resource "aws_default_subnet" "default_az1" {
    availability_zone = data.aws_availability_zones.available.names[0]
  }

  resource "aws_default_subnet" "default_az2" {
    availability_zone = data.aws_availability_zones.available.names[1]
  }

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}

# resource "aws_instance" "terraform_lesson" {
#   ami                    = "ami-097c5c21a18dc59ea"
#   instance_type          = "t3.micro"
#   vpc_security_group_ids = [aws_security_group.first_group.id]
#   user_data              = templatefile("user_data.sh.tpl",{
#     f_name               = "Kate",
#     l_name               = "Kulikovich",
#     names                = ["Vasya","Kolya","Petya","Masha"]
#   })
#   metadata_options {
#     http_tokens = "optional"
#   }

#   tags = {
#     Name    = "first_instance"
#     Owner   = "kulerock"
#     Project = "Terraform Lessons"
#   }

# }

