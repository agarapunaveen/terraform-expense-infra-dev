module "vpc" {
source = "git::https://github.com/agarapunaveen/terraform.git?ref=master"
  comman_tags = var.comman_tags
  project_name = var.project_name
 aws_subnet_public = var.aws_subnet_public
  aws_subnet_private = var.aws_subnet_private
  aws_subnet_database = var.aws_subnet_database
  is_peering = var.is_peering
}