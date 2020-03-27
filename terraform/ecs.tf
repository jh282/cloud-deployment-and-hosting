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
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "cdah" {
  family                = var.name
  container_definitions = data.template_file.container_definition.rendered
}

resource "aws_iam_role" "ecs_service" {
  name = "${var.name}-ecs-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
	{
	  "Sid": "",
	  "Effect": "Allow",
	  "Principal": {
		"Service": "ecs.amazonaws.com"
	  },
	  "Action": "sts:AssumeRole"
	}
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
