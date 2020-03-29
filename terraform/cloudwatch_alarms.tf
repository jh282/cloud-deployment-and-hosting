## ECS CPU Metric Alarms

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${aws_ecs_service.cdah.name}-cpu-utilization-above-80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = module.asg.this_autoscaling_group_name
  }

  alarm_description = "This alarm monitors ${aws_ecs_service.cdah.name} cpu utilization for scaling up"
  alarm_actions     = [aws_appautoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${aws_ecs_service.cdah.name}-cpu-utilization-below-5"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    AutoScalingGroupName = module.asg.this_autoscaling_group_name
  }

  alarm_description = "This alarm monitors ${aws_ecs_service.cdah.name} cpu utilization for scaling down"
  alarm_actions     = [aws_appautoscaling_policy.scale_down.arn]
}
