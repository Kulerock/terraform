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

# variable "common_tags" {
#   description = "Please, enter the common tags"
#   type        = map
#   default     = {

#   }
# }