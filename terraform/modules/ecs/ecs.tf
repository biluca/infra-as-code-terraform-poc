variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "listener_rule" {
    type = string
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "main_task_definition" {
  family                   = "main-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
  [
    {
      "name": "main-container",
      "image": "https://hub.docker.com/r/biluca91/prime-finder:1.0.1",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/prime-finder",
          "awslogs-region": "us-east-2",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/prime-finder"
  retention_in_days = 3
}

# Create an ECS Cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = "main-ecs-cluster"

  tags = {
    Name = "Main Cluster"
  }
}


resource "aws_ecs_service" "main_service" {
  name            = "main-service"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.main_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "main-container"
    container_port   = 80
  }

  depends_on = [var.listener_rule] # Ensure ALB listener rule is created first
}

