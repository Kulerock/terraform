variable "region" {
  description = "Please, enter the region"
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "Please, enter the instance type"
  default     = "t3.micro"
}

variable "allow_ports" {
  description = "Please, enter the ports"
  type        = list
  default     = ["80", "443"]
}

variable "vpc_id" {
  default     = "vpc-04638fa44d53e81de" 
}

variable "subnets_id" {
  type        = list
  default     = ["subnet-0033d5cc4ff06208c", "subnet-01c0d6e07209094ca", "subnet-03282908de6da2cc6"]
}

# variable "common_tags" {
#   description = "Please, enter the common tags"
#   type        = map
#   default     = {

#   }
# }