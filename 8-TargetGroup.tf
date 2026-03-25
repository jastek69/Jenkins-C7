# CALIFORNIA TARGET GROUPS for LOAD BALANCER

/*
resource "aws_lb_target_group" "ca_lb_tg80" {
  provider = aws.california
  name     = "ca-lb-tg80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.CA_VPC.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name    = "ca-LB-TargetGroup"
    Service = "LoadBalancer"
    Owner   = "Blackneto"
    Project = "Test"
  }
}
*/
/*
resource "aws_lb_target_group" "ca_lb_tg443" {
  provider = aws.california
  name     = "ca-tg443"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.CA_VPC.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name    = "ca-lb-TargetGroup443"
    Service = "LoadBalancer"
    Owner   = "User"
    Project = "TMMC"
  }
}
*/