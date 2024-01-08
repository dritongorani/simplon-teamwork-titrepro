terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

}

# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.accesskeyaws_driton
  secret_key = var.secretkey_driton

}


####AWS VPC ######
resource "aws_vpc" "main" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "DR_VPC"
  }
}

####EC2 Instance ####
resource "aws_instance" "myFirstInstance" {
  ami                    = var.ami_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.dg_securityg.id]
  user_data = "${file("script.sh")}"
  tags = {
    Name     = var.tag_name
    Schedule = "FrenchOfficeHours"
  }
}

##Security Group########
resource "aws_security_group" "dg_securityg" {
  name        = var.security_group
  description = "security group for home cinema"


  ingress {
    from_port   = 8123
    to_port     = 8123
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

