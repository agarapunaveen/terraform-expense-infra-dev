variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "comman_tags" {
  default = {
    Project="expense"
    Terraform=true
  }
}

variable "zone_id" {
  default = "Z00015921P6S67JKOVKAA"
}