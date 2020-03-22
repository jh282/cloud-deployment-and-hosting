terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-cdah"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table =  "terraform-state-locks"
    encrypt        = true
  }
}
