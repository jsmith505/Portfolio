provider "aws" {
  region = var.aws_region
}

resource "aws_ecs_cluster" "this" {
  name = "cloudops-dashboard-cluster"
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "cloudops-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "cloudops-backend"
      image     = "${var.docker_image}:${var.docker_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name            = "cloudops-backend-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group]
  }
}
