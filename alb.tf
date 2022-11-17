resource "aws_lb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.lb_subnet_ids
  security_groups = [ aws_security_group.alb.id ]

  access_logs {
    enabled = false
    bucket = "" # TF complains if this field is absent
  }

  tags = {
    Environment = var.name
  }
}

# Feeds data from already created Lambda TF module
resource "aws_lb_target_group_attachment" "a" {
  target_group_arn = aws_lb_target_group.echo.arn
  target_id        = aws_lambda_function.echo.arn
  depends_on       = [ aws_lambda_permission.with_lb ]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.echo.arn
  }
}

output "lb_dns_name" {
  value = aws_lb.alb.dns_name
}
