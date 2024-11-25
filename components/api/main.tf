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
    container_port     = 4000
    connection_string  = var.connection_string
    api_key            = var.api_key
    log_group = var.log_group
  }
}

resource "aws_ecs_task_definition" "service" {
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
