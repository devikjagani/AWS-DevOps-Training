terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}


module "dev" {
  source        = "./modules/ec2"
  ami_id        = "ami-0437df53acb2bbbfd"
  instance_type = "t3.micro"
  tags = {
    Name = "dev"
  }
}


module "prod" {
  source        = "./modules/ec2"
  ami_id        = "ami-0437df53acb2bbbfd"
  instance_type = "t3.medium"
  tags = {
    Name = "prod"
  }
}
