terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "network" {
  source        = "../../modules/network"
  env           = "prod"
  vpc_cidr      = "10.1.0.0/16"
  subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
}

module "compute" {
  source         = "../../modules/compute"
  env            = "prod"
  instance_count = 2
  vpc_id         = module.network.vpc_id
  subnet_ids     = module.network.subnet_ids
}

module "logging" {
  source  = "../../modules/logging"
  env     = "prod"
  vpc_id  = module.network.vpc_id
}
