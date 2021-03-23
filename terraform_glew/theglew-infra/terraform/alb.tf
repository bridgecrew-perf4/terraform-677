# alb.tf

resource "aws_alb" "production" {
  name            = "lb-production"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb_production.id]
}

resource "aws_alb" "develop" {
  name            = "lb-develop"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb_develop.id]
}

resource "aws_alb" "staging" {
  name            = "lb-staging"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb_staging.id]
}

## Target groups

resource "aws_alb_target_group" "production_target_group" {
  name        = "production-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "develop_target_group" {
  name        = "develop-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "staging_target_group" {
  name        = "staging-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "production_front_end" {
  load_balancer_arn = aws_alb.production.id
  port              = 443
  protocol          = "HTTPS"
  depends_on        = [aws_alb_target_group.production_target_group]
  certificate_arn   = var.certificate_arn


  default_action {
    target_group_arn = aws_alb_target_group.production_target_group.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "http_production" {
  load_balancer_arn = aws_alb.production.id
  port              = 80
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.production_target_group]

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "develop_front_end" {
  load_balancer_arn = aws_alb.develop.id
  port              = 443
  protocol          = "HTTPS"
  depends_on        = [aws_alb_target_group.develop_target_group]
  certificate_arn   = var.certificate_arn


  default_action {
    target_group_arn = aws_alb_target_group.develop_target_group.id
    type             = "forward"
  }
}


resource "aws_lb_listener" "http_develop" {
  load_balancer_arn = aws_alb.develop.id
  port              = 80
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.develop_target_group]

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "staging_front_end" {
  load_balancer_arn = aws_alb.staging.id
  port              = 443
  protocol          = "HTTPS"
  depends_on        = [aws_alb_target_group.staging_target_group]
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.staging_target_group.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "http_staging" {
  load_balancer_arn = aws_alb.staging.id
  port              = 80
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.staging_target_group]

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}