variable "main_vpc_id"{
    type = string
}

resource "aws_lb_target_group" "main_target_group" {
  name     = "my-target-group"
  port     = 80 
  protocol = "HTTP" 
  vpc_id   = var.main_vpc_id
  target_type = "ip" 

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = {
    Name = "Main Target Group"
  }
}

output "main_target_group_arn" {
  value = aws_lb_target_group.main_target_group.arn
}
