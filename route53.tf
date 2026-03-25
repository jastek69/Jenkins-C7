data "aws_route53_zone" "main" {
  name         = "jastek.click."
  private_zone = false
}


# Jenkins ALB origin record (points directly to this module's ALB)
resource "aws_route53_record" "taaops_origin_to_alb01" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.alb_origin_fqdn
  type    = "A"

  alias {
    name                   = aws_lb.jenkins_alb.dns_name
    zone_id                = aws_lb.jenkins_alb.zone_id
    evaluate_target_health = false
  }
}
