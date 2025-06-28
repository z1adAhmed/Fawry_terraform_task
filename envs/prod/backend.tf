terraform {
  backend "s3" {
    bucket         = "poc-tf-state-ziad"
    key            = "prod/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
