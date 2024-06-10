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

variable "zone_name" {
  default = "naveencloud.online"
}