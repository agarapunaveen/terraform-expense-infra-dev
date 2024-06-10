module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"

  instance_type          = "t2.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
    ami = data.aws_ami.ami_info.id
    user_data = file("bastion.sh")
  tags = merge(
    var.comman_tags,
    {
    Name="${var.project_name}-${var.environment}-bastion"
  }
  )
}