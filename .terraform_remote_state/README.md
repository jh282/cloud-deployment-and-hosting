# Terraform Remote State Resources

Modules containing resources required for s3 Remote State.

Includes:

- aws_s3_bucket (where the state file will be stored)
- aws_dynamodb_table (where the state file lock will be stored)

These resources will need to be referenced in a Terraform S3 Backend configuration block.
