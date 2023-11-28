provider "aws" {
  alias = "acm"
  region = "us-east-1"
}


resource "aws_route53_zone" "my_hosted_zone" {
  name          = "techscrum-dev.disite.link"
  force_destroy = false
}

# resource "aws_route53_zone" "primary" {
#  name          = "disite.link"
#  comment       = "Route 53 Zone"
#  force_destroy = false  # You may want to set this to false to prevent accidental deletion
#}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "TechScrum Cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "cert_validation" {
    for_each = {
      for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
        name   = dvo.resource_record_name
        record = dvo.resource_record_value
        type   = dvo.resource_record_type
      }
    }

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    type            = each.value.type
    zone_id         = "Z09214101IU8I71TAQICS"
    ttl             = 60
}
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
resource "aws_route53_record" "www" {
  zone_id = "Z09214101IU8I71TAQICS"
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn_static_site.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex" {
  zone_id = "Z09214101IU8I71TAQICS"
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn_static_site.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_static_site.hosted_zone_id
    evaluate_target_health = false
  }
}