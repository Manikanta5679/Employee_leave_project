variable "project" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "alb_sg_id" {
  type = string
}
variable "target_port" {
  type = number
}
