resource "aws_wafv2_web_acl" "waf_techscurm" {
  name     = "north_america_access_control"
  scope    = "CLOUDFRONT"
  provider  = aws.cloudfront_region

  default_action {
      allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-rule-metric-name"
    sampled_requests_enabled   = false
  }


  rule {
    name     = "Control-NA-IP-Traffic"
    priority = 1

    action {
      captcha {}
    }
    
    statement {
      geo_match_statement {
        country_codes = ["US", "CA"]
      }
    }

    captcha_config {
      immunity_time_property {
        immunity_time = 300
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
  }
  }
}