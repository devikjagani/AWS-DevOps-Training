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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Generate a random private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair from generated public key
resource "aws_key_pair" "generated_key" {
  key_name   = "mywebserver"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save the private key to a file (local)
resource "local_file" "private_key_pem" {
  content              = tls_private_key.ec2_key.private_key_pem
  filename             = "${path.module}/aws/mywebserver.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

resource "aws_security_group" "http_server_sg" {
  name        = "http_server_sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami                         = "ami-0437df53acb2bbbfd"
  instance_type               = "t3.medium"
  key_name                    = aws_key_pair.generated_key.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.http_server_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              usermod -a -G apache ec2-user
              chmod 755 /var/www/html
              echo "Welcome to Webserver $(hostname -f)" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Terraform-HTTP-Server"
  }

  depends_on = [local_file.private_key_pem]
}