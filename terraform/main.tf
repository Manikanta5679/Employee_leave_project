provider "aws" {
  region = var.region
}

# VPC
module "vpc" {
  source   = "./modules/vpc"
  project  = var.project
  vpc_cidr = var.vpc_cidr
}

# Subnets
module "subnets" {
  source               = "./modules/subnets"
  project              = var.project
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

# Route tables + NAT + IGW
module "routetables" {
  source             = "./modules/routetables"
  project            = var.project
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
}

# Security groups
module "security_groups" {
  source        = "./modules/security_groups"
  project       = var.project
  vpc_id        = module.vpc.vpc_id
  instance_port = var.instance_port
}

# ECR
module "ecr" {
  source = "./modules/ecr"
  name   = "${var.project}-backend"
}

# ALB
module "alb" {
  source         = "./modules/alb"
  project        = var.project
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.subnets.public_subnet_ids
  alb_sg_id      = module.security_groups.alb_sg_id
  target_port    = var.instance_port
}

# IAM Instance Profile
module "iam_instance_profile" {
  source  = "./modules/iam_instance_profile"
  project = var.project
}

# EC2
module "ec2" {
  source                    = "./modules/ec2"
  project                   = var.project
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  subnet_id                 = element(module.subnets.public_subnet_ids, 0)
  security_group_ids        = [module.security_groups.instance_sg_id]
  iam_instance_profile_name = module.iam_instance_profile.instance_profile_name
  associate_public_ip       = var.associate_public_ip
  key_name                  = var.key_name
  public_key_path           = var.public_key_path
  aws_region                = var.region
  aws_account_id            = var.aws_account_id
  ecr_repo_url              = module.ecr.repository_url
  instance_port             = var.instance_port
}
