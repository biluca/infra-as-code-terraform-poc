variable security_group{
    type = list(string)
}

variable subnets{
    type = list(string)
}

variable target_group_arn{
    type = string
}

resource "aws_lb" "main_app_load_balancer" {
  name               = "MainAppLoadBalancer"
  internal           = false  
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets            = var.subnets

  tags = {
    Name = "Main App Load Balancer"
  }
}

resource "aws_lb_listener" "main_listener" {
  load_balancer_arn = aws_lb.main_app_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "main_listener_rule" {
  listener_arn = aws_lb_listener.main_listener.arn
  priority     = 1 

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = ["prime-finder/*"] 
    }
  }
}

output "main_listener_rule_id" {
  value = aws_lb_listener_rule.main_listener_rule.id
}

output "app_load_balancer_dns_name" {
  value = aws_lb.main_app_load_balancer.dns_name
}

