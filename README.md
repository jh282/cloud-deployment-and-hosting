# Cloud Deployment and Hosting

## Solution

This creates an ECS Cluster on a EC2-ASG in a VPC spread across 3 availability zones in a single region adding resiliency. It pulls an image from ECR (which I pushed my website build to) and serves it on HTTP. Access to the site is possible by hitting the public DNS of the ALB, which routes the traffic to ECS using dynamic port mapping.

Metrics are exported from the ECS Service to cloudwatch, from which alarms can trigger autoscaling of the container capacity. Currently just CPU is being looked at to demonstrate the concept.

The infrastructure is managed by Terraform and can be scaled up easily by altering the ec2 and ecs capacity variables in variables.tf, which will scale the size of the ECS service as well as the EC2 ASG it resides on.

![alt text](https://raw.githubusercontent.com/jh282/cloud-deployment-and-hosting/develop/cloud_deployment_aws.png "Infrastructure Diagram")

## Automation

The infrastructure can be checked, applied and destroyed using the Circle-CI based terraform build pipeline. Also implemented in the repo as part of the pull request checks to ensure code looks valid and plans successfully before merging.

It contains the following build stages:

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

The DNS that the site can be accessed from should be outputted at the end of the apply.

## Further Improvements

Changes I would have liked to implement next to improve the solution given more time:

- Create a hosted domain for the site, and enable a HTTPS listener on the ALB.
- Add metric alarm driven auto-scaling to the EC2 ASG (currently just using fixed capacity values)
- Add Network ACL security to the subnets, adding another layer of security on top of the security groups, limiting the possible flow of traffic to what I need.
- Add testing to the build pipeline to ensure the service has come up and is accessible as expected.
- Restructure the code into more meaningful modules, making them more segmented and  easier to manage going forward.
- Export application logs from the containers to a centralised place, e.g. Cloudwatch. Allowing alerting to be implemented to identify any problems with the service.
- Implement Terraform workspaces so that isolated infrastructure can be deployed for different environments or branches using the same code throughout. This allows for more testing earlier on in the development process, adding assurances that the code will work before moving it to the next stage.
