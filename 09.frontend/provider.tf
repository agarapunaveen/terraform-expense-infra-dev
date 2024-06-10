terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  #  backend "s3" {
  #   bucket="prods-s3"
  #   key="vpc-expense-dev-sg"
  #   region="us-east-1"
  #   dynamodb_table="prod-table"
  # }
}

provider "aws" {
  region = "us-east-1"
}

