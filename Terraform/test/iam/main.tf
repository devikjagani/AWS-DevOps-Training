terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"  # Change this as per your requirement
}

variable "names" {
  default = ["one", "two", "three"]
}

resource "aws_iam_user" "my_iam_users" {
  for_each = toset(var.names)
  name     = each.value
}
