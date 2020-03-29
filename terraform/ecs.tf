## ECS Cluster & Service

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name   = var.name
}

resource "aws_ecs_service" "cdah" {
  name            = var.name
  cluster         = module.ecs.this_ecs_cluster_id
  task_definition = aws_ecs_task_definition.cdah.arn
  desired_count   = 3
  iam_role        = aws_iam_role.ecs_service.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs_service]

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = var.name
    container_port   = var.container_port
  }
}

resource "aws_ecs_task_definition" "cdah" {
  family                = var.name
  container_definitions = data.template_file.container_definition.rendered
}

## ECS Service Autoscaling resources

resource "aws_appautoscaling_target" "ecs_service" {
  resource_id        = "service/${module.ecs.this_ecs_cluster_name}/${aws_ecs_service.cdah.name}"
  role_arn           = aws_ecs_service.cdah.id
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_ecs_capacity
  max_capacity       = var.max_ecs_capacity
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name                    = "${aws_ecs_service.cdah.name}-scale-up"
  resource_id             = "service/${module.ecs.this_ecs_cluster_name}/${aws_ecs_service.cdah.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = aws_appautoscaling_target.ecs_service.service_namespace
  policy_type             = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  name                    = "${aws_ecs_service.cdah.name}-scale-down"
  resource_id             = "service/${module.ecs.this_ecs_cluster_name}/${aws_ecs_service.cdah.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = aws_appautoscaling_target.ecs_service.service_namespace
  policy_type             = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

## ECS IAM

resource "aws_iam_role" "ecs_service" {
  name               = "${var.name}-ecs-role"
  assume_role_policy = data.template_file.ecs_assume_role_policy.rendered
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
