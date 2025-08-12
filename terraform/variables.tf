variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "associate_public_ip" {
  type = bool
}

variable "key_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "instance_port" {
  type = number
}
variable "public_key_path" {
  description = "Path to your public SSH key"
  type        = string
}
