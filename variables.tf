variable "lb_subnet_ids" {
  type = list
  description = "The subnet IDs to put the LB into"
  # in the default VPC in eu-central-1
  default = [ "subnet-db3f8cb1", "subnet-dca65a90" ]
}

variable "vpc_id" {
  type = string
  default = "vpc-87f13aed"
}

variable "aws_region" {
  type = string
  default = "eu-central-1"
}
