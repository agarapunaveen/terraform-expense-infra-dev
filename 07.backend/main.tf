module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.project_name}-${var.environment}-backend"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.private_subnet_ids.value),0)
    ami = data.aws_ami.ami_info.id
  tags = merge(
    var.comman_tags,
    {
    Name="${var.project_name}-${var.environment}-backend"
  }
  )
}

resource "null_resource" "backend" {
  triggers = {                    # this will triggers everytime,when instance is created
   instanc_id= module.backend.id 
}
connection{
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host=module.backend.private_ip
}
provisioner "file" {
  source = "${var.comman_tags.Component}.sh"
  destination = "/tmp/${var.comman_tags.Component}.sh"
}
provisioner "remote-exec" { 
  inline = [ 
    "chmod +x /tmp/${var.comman_tags.Component}.sh",
    "sudo sh /tmp/${var.comman_tags.Component}.sh ${var.comman_tags.Component} ${var.environment}"
   ]
}

}

resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend.id
  state       = "stopped"
  # stop the server only when null resource provisioning is completed
  depends_on = [ null_resource.backend ]
}

# your search aws ami from instance
resource "aws_ami_from_instance" "backend" {
  name               = "${var.project_name}-${var.environment}-backend"
  source_instance_id = module.backend.id
  depends_on = [ aws_ec2_instance_state.backend ]
}



resource "null_resource" "backend_delete" {
  triggers = {
   instanc_id= module.backend.id
}
connection{
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host=module.backend.private_ip
}
# through command line we can delete the instances using local-exec
provisioner "local-exec" {
 command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"
}

depends_on = [ aws_ami_from_instance.backend ]

}

resource "aws_lb_target_group" "backend" {
  name     = "${var.project_name}-${var.environment}-${var.comman_tags.Component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
  }
}

resource "aws_launch_template" "backend" {
  name = "${var.project_name}-${var.environment}-${var.comman_tags.Component}"
  image_id = aws_ami_from_instance.backend.id
  instance_type = "t3.micro"
 update_default_version = true  #set the latest version to default

  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.comman_tags,
      {
      Name = "${var.project_name}-${var.environment}-${var.comman_tags.Component}"
    }
    )
  }

}

resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project_name}-${var.environment}-${var.comman_tags.Component}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns = [aws_lb_target_group.backend.arn]
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
 

   instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-${var.comman_tags.Component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "backend" {
  name                   = "${var.project_name}-${var.environment}-${var.comman_tags.Component}"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 10.0
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = data.aws_ssm_parameter.aws_lb_listener.value
  priority     = 100 # less number will be first validated

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.environment}.${var.zone_name}"]
    }
  }
}