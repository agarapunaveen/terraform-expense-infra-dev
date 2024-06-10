resource "aws_key_pair" "deployer" {
  key_name   = "openvpn"
  public_key = file("~/desktop/openvpn.pub")
  # public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSa2ouiRmaOvVLGV0S7Yse1b33oGodffCtQz25SMH7STbainhKN4ORbtHTjzJRP5cEtP+nnWsKPSdw8jtb2i2F4Hm1SsL04NI+SQyUo6l7Z3jtaxSYYfZ1u4wMPjAgyFXpuWB3ArlNFVobbWSrs3L2502N2ZTb6fSZS8dJ40rEm/LAai/UU28nu5s+VhBt3cS3r02JWlPoE8Ru+MVGlojbc+/ZrjFXXMP4WVWEFot7H0IadRV+EDPjO4h0rWJIwek5I/LPekqcXNnr21HZNdjU8WJU8d9mTA4RNeF5G1UVBU1hLX8r6D2tCaPOCJ4HgG15eJ9kxuQuM6Twz++ie3K5WFVFgv68A3H4OyHzOJFDYNecYIZ55qnSAMppWL66Wb7aXYKR38QwtulOEkMgDgiT9+RdRdUHl/+9ubjKDGth25noHivIi3m4yGVGno3ScAO8li3CvOno0L6WNWTJl4KpuAAkkZoFXTdPDrb63mjjJqfMJBqZdemynXOCiZ7Y8PE= pc@DESKTOP-EFIJKML"
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
key_name = aws_key_pair.deployer.key_name
  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t2.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
    ami = data.aws_ami.example.id
  tags = merge(
    var.comman_tags,
    {
    Name="${var.project_name}-${var.environment}-vpn"
  }
  )
}