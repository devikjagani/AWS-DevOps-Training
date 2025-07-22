terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.3.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  #count         = "2"

  tags = {
    Name = "test-ec2"
  }
}
