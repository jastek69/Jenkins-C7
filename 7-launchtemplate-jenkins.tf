# Launch Template for Port 80
/*
resource "aws_launch_template" "ec2-cali-jenkins-80" {  
  name_prefix   = "ec2-cali-jenkins-80"
  image_id      = "ami-038bba9a164eb3dc1"
  instance_type = "t3.medium"

  key_name = "MyLinuxBox"

  vpc_security_group_ids = [aws_security_group.ec2-cali-jenkins-sg80.id]

  user_data = filebase64("${path.module}/scripts/user_data.sh")
  

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "ec2-cali-80"
      Service = "application1"
      Owner   = "Blackneto"
      Planet  = "Taa"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*
# Launch Template for Port 443
resource "aws_launch_template" "ec2-cali-443" {  
  name_prefix   = "ec2-cali-443"
  image_id      = "ami-038bba9a164eb3dc1"
  instance_type = "t3.medium"

  key_name = "MyLinuxBox"

  vpc_security_group_ids = [aws_security_group.ca_SL01-SG01-443.id]

  user_data = filebase64("${path.module}/scripts/user_data_sec.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "cali-SysLog-443"
      Service = "application1"
      Owner   = "Blackneto"
      Planet  = "Taa"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
*/