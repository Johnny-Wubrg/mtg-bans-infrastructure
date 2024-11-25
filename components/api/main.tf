data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

locals {
  container_port = 4000
}


resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  description = "allow inbound access from the ALB only"

  ingress {
    protocol        = "tcp"
    from_port       = local.container_port
    to_port         = local.container_port
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.alb_security_group]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-mtg-bans-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "template_file" "mtg_bans_api" {
  template = file("${path.module}/mtg_bans_api.json.tpl")
  vars = {
    aws_ecr_repository = var.repository_url
    tag                = "latest"
    region             = var.region
    app_port           = 80
    container_port     = local.container_port
    connection_string  = var.connection_string
    api_key            = var.api_key
    log_group          = var.log_group
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "mtg-bans"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.mtg_bans_api.rendered
  tags = {
    Environment = var.environment
    Application = "mtg-bans"
  }
}

resource "aws_ecs_cluster" "api" {
  name = "mtg-bans-cluster"
}

resource "aws_ecs_service" "api" {
  name            = "mtg-bans"
  cluster         = aws_ecs_cluster.api.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "mtg-bans"
    container_port   = local.container_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
  tags = {
    Environment = var.environment
    Application = "mtg-bans"
  }
}
