
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

# data "aws_ssm_parameter" "frontend_sg_id" {
#   name = "/${var.project_name}/${var.environment}/frontend_sg_id"
# }

# data "aws_ssm_parameter" "backend_sg_id" {
#   name = "/${var.project_name}/${var.environment}/backend_sg_id"
# }

# data "aws_ssm_parameter" "database_sg_id" {
#   name = "/${var.project_name}/${var.environment}/database_sg_id"
# }

# data "aws_ssm_parameter" "vpn_sg_id" {
#   name = "/${var.project_name}/${var.environment}/vpn_sg_id"
# }

# data "aws_ssm_parameter" "app_alb_sg_id" {
#   name = "/${var.project_name}/${var.environment}/app_alb_sg_id"
# }

# data "aws_ssm_parameter" "bastion_sg_id" {
#   name = "/${var.project_name}/${var.environment}/bastion_sg_id"
# }