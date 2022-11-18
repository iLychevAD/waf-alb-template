
resource "aws_wafv2_web_acl" "web-acl" {
  name  = "${local.name}-2"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "allow-foo-or-bar--waf-acme-lb--example--com---static---any"
    priority = 0
    statement {
        and_statement {
            statement {
              regex_match_statement {
                regex_string = "(foo|bar).waf-acme-lb.example.com"
                field_to_match {
                  single_header {
                    name = "host"
                  }
                }
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
            statement {
              regex_match_statement {
                regex_string = "/static/*"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
        }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${local.name}-waf-whitelist"
      sampled_requests_enabled   = false
    }
    action {
      allow {}
    }
  }

  rule {
    name     = "allow-foo-or-bar--waf-acme-lb--example--com---webhook"
    priority = 1
    statement {
        and_statement {
            statement {
              regex_match_statement {
                regex_string = "(foo|bar).waf-acme-lb.example.com"
                field_to_match {
                  single_header {
                    name = "host"
                  }
                }
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
            statement {
              byte_match_statement {
                search_string = "/webhook"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
                positional_constraint = "EXACTLY"
              }
            }
        }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${local.name}-waf-whitelist"
      sampled_requests_enabled   = false
    }
    action {
      allow {}
    }
  }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${local.name}-waf"
      sampled_requests_enabled   = false
    }

}

resource "aws_wafv2_web_acl_association" "assoc" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web-acl.arn
}
