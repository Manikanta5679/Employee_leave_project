variable "project" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile_name" {
  type = string
}

variable "associate_public_ip" {
  type = bool
}

variable "key_name" {
  description = "The name for the SSH key pair to create in AWS"
  type        = string
}

variable "public_key_path" {
  description = "Path to your public SSH key (.pub)"
  type        = string
}

variable "name" {
  type    = string
  default = "app-instance"
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "ecr_repo_url" {
  type = string
}

variable "instance_port" {
  type = number
}
