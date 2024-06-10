variable "project_name" {
  default = "expense"
}
variable "environment" {
  default = "dev"
}

variable "comman_tags" {
  default = {
    Project="expense"
    Environment="dev"
    terraform="true"
  }
}

variable "aws_subnet_public" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "aws_subnet_private" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "aws_subnet_database" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}
variable "is_peering" {
  default = true
}