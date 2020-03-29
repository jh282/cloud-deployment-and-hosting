# Cloud Deployment and Hosting

## Solution

This creates an AWS with EC2 backed ECS Cluster in a VPC spread across 3 availability zones in a single region. It pulls an image from ECR (which I stored my website build in) and serves on HTTP. Users currently access this site by hitting the public DNS of the ALB, which routes the traffic to ECS using dynamic port mapping.

Metrics are exported from the ECS Service to cloudwatch, from which alarms can trigger autoscaling of the container capacity.

The infrastructure is managed by Terraform and can be scaled up easily by altering the ec2 and ecs capacity variables in variables.tf, which will scale the size of the ECS service as well as the EC2 ASG it resides on.

![alt text](https://raw.githubusercontent.com/jh282/cloud-deployment-and-hosting/develop/cloud_deployment_aws.png "Infrastructure Diagram")

## Automation

The infrastructure can be checked, applied and destroyed using the Circle-CI based terraform build pipeline.

It runs the following build stages:

- Terraform validation
- Terraform linting
- Terraform plan
- Terraform apply to AWS (requires manual approval in CircleCI)
- Terraform destroy to AWS (requires manual approval in CircleCI)

The configuration can be found under .circleci/config.yaml


## Build Instructions

This can be built either by using the Circle-CI pipeline, or by running terraform provision commands. In both cases the standard AWS environment variable credentials will need to be provided.

##### Terraform Provision Commands

```
terraform init terraform/
```

```
terraform apply terraform/
```


## Further Work
