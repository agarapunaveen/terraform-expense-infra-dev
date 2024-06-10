module "frontend" {
  source = "../security-group-sg"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.comman_tags
  sg_name = "frontend"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "backend" {
  source = "../security-group-sg"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.comman_tags
  sg_name = "backend"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "database" {
  source = "../security-group-sg"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.comman_tags
  sg_name = "database"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "bastion" {
  source = "../security-group-sg"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.comman_tags
  sg_name = "bastion"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "app_alb" {
  source = "../security-group-sg"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.comman_tags
  sg_name = "app_alb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "vpn" {
  source = "../security-group-sg"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.comman_tags
  sg_name = "vpn"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}
module "web_alb" {
  source = "../security-group-sg"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.comman_tags
  sg_name = "web_alb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id = module.database.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.database.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.database.sg_id
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "vpn_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id 
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

