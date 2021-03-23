# ecs.tf

# Template schematic files
data "template_file" "production_schema" {
  template = file("${path.module}/templates/ecs/app.json.tpl")

  vars = {
    app_image      = var.app_image
    cluster_name   = "production"
    app_name       = "production"
    log_group      = "production"
    app_port       = var.app_port
    fargate_cpu    = var.fargate_production_cpu
    fargate_memory = var.fargate_production_memory
    aws_region     = var.aws_region
  }
}

data "template_file" "develop_schema" {
  template = file("${path.module}/templates/ecs/app.json.tpl")

  vars = {
    app_image      = var.app_image
    cluster_name   = "develop"
    app_name       = "develop"
    log_group      = "develop"
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

data "template_file" "staging_schema" {
  template = file("${path.module}/templates/ecs/app.json.tpl")

  vars = {
    app_image      = var.app_image
    cluster_name   = "staging"
    app_name       = "staging"
    log_group      = "staging"
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}



# Clusters definition
resource "aws_ecs_cluster" "production" {
  name = "production"
}

resource "aws_ecs_cluster" "develop" {
  name = "develop"
}

resource "aws_ecs_cluster" "staging" {
  name = "staging"
}

# Task definitions

resource "aws_ecs_task_definition" "production" {
  family                   = "production"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_production_cpu
  memory                   = var.fargate_production_memory
  container_definitions    = data.template_file.production_schema.rendered
}

resource "aws_ecs_task_definition" "develop" {
  family                   = "develop"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.develop_schema.rendered
}


resource "aws_ecs_task_definition" "staging" {
  family                   = "staging"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.staging_schema.rendered
}

resource "aws_ecs_service" "production" {
  name            = "ecs-production-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.production.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_production.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.production_target_group.id
    container_name   = "production"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.production_front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_service" "develop" {
  name            = "ecs-develop-service"
  cluster         = aws_ecs_cluster.develop.id
  task_definition = aws_ecs_task_definition.develop.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_develop.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.develop_target_group.id
    container_name   = "develop"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.develop_front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_service" "staging" {
  name            = "ecs-staging-service"
  cluster         = aws_ecs_cluster.staging.id
  task_definition = aws_ecs_task_definition.staging.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_staging.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.staging_target_group.id
    container_name   = "staging"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.staging_front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}