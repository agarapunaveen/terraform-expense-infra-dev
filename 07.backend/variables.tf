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
    Terraform=true
    Component="backend"
  }
}
variable "zone_name" {
  default = "naveencloud.online"
}