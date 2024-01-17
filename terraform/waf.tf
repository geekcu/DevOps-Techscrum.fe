resource "aws_wafv2_web_acl" "waf_techscurm" {
  name     = "North America Access Control"
  scope    = "CLOUDFRONT"
  capacity = 500

  default_action {
      allow {}
  }

  rule {
    name     = "Control-NA-IP-Traffic"
    priority = 1

    action {
      challenge {}
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
}
  