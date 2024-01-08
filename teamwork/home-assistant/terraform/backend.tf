terraform {
  backend "s3"{
    region = "eu-west-1"
    bucket = "drbuckets3test"
    key = "terraform/terraform.tfstate"
  }
}