output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.subnets.public_subnet_ids
}

output "private_subnets" {
  value = module.subnets.private_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}
