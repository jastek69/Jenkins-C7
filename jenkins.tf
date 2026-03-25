# Security Group for Jenkins

resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.CA-VPC-Jenkins.id

  # UI traffic from the ALB only
  ingress {
    description      = "Jenkins UI Direct"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups  = [aws_security_group.taaops_alb01_sg443.id]
  }

  # Healthcheck (Nginx) from the ALB only
  ingress {
    description      = "Healthcheck via ALB"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    security_groups  = [aws_security_group.taaops_alb01_sg443.id]
  }

  # Administrative SSH from a controlled CIDR
  ingress {
    description = "Admin SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ssh_cidr]
  }

  # Egress open (tighten later if needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name    = "jenkins-sg"
      Service = "jenkins"
    }
  )
}


# Target group for Jenkins (port 8080, health on 8081)
resource "aws_lb_target_group" "jenkins_tg" {
  name     = "${local.name_prefix}-jenkins-8080"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.CA-VPC-Jenkins.id
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    port     = "8081"
    path     = "/"
    matcher  = "200-399"
    interval = 30
    timeout  = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${local.name_prefix}-jenkins-8080"
  }
}



resource "aws_lb_listener" "jenkins_alb_listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "jenkins_alb_https_listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # Use provided cert ARN if set; otherwise the ACM cert created in alb-https.tf (local.alb_origin_cert_arn)
  certificate_arn   = local.alb_origin_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
}


# HTTP listener rule (path-based)
resource "aws_lb_listener_rule" "jenkins_http" {
  listener_arn = aws_lb_listener.jenkins_alb_listener.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
  condition {
    path_pattern {
      values = ["/jenkins*", "/login*", "/static/*"]
    }
  }
}

# HTTPS listener rule (forward from 443)
resource "aws_lb_listener_rule" "jenkins_https" {
  listener_arn = aws_lb_listener.jenkins_alb_https_listener.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
  condition {
    path_pattern {
      values = ["/jenkins*", "/login*", "/static/*"]
    }
  }
}


# EC2 for Jenkins
resource "aws_instance" "jenkins" {
  ami                    = var.ec2_ami_id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.cali-public-us-west-1a.id
  associate_public_ip_address = true # Optional, for direct access if needed# or use/keep EIP resource
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = var.jenkins_iam_instance_profile != "" ? var.jenkins_iam_instance_profile : null
  key_name               = "JenkinsKp"  # or your key pair name
  user_data_base64       = filebase64("${path.module}/scripts/user_data_jenkins_full.sh")
  tags = merge(var.common_tags, { Name = "${local.name_prefix}-jenkins" })
}


# Attach Jenkins instance to Target Group
resource "aws_lb_target_group_attachment" "jenkins_instance" {
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}



resource "aws_lb" "jenkins_alb" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.taaops_alb01_sg443.id]
  subnets            = [aws_subnet.cali-public-us-west-1a.id, aws_subnet.cali-public-us-west-1b.id]

  tags = merge(
    var.common_tags,
    {
      Name    = "${local.name_prefix}-alb"
      Service = "jenkins"
    }
  )
}


# Elastic IP for Jenkins instance (optional, for direct access if needed)
/*
resource "aws_eip" "jenkins_eip" {
  domain = "vpc"
  instance = aws_instance.jenkins.id
}
*/