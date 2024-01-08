variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
  type        = string
}

variable "key_name" {
  description = " SSH keys to connect to ec2 instance"
  default     = "driton_key"
  type        = string
}

variable "instance_type" {
  description = "instance type for ec2"
  default     = "t2.medium"
  type        = string
}

variable "security_group" {
  description = "Name of security group"
  default     = "dr_gitlab_ci"
  type        = string
}

variable "tag_name" {
  description = "Tag Name of for Ec2 instance"
  default     = "dr_gitlab_ci_test"
  type        = string
}
variable "ami_id" {
  description = "AMI for debian Ec2 instance"
  default     = "ami-0f98479f8cd5b63f6"
  type        = string
}

####Secret variables### 

variable "secretkey_driton" {
  description = "secretawskey"
  type        = string
}

variable "accesskeyaws_driton" {
  description = "acesskey"
  type        = string
}
