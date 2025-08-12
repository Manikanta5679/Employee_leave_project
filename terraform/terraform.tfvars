project = "employee-leave"
region  = "us-east-1"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

azs = ["us-east-1a", "us-east-1b"]


ami_id              = "ami-020cba7c55df1f615"
instance_type       = "t3.micro"
associate_public_ip = true
key_name            = "Myec2key"
public_key_path     = "/home/mkubuntu/.ssh/id_rsa.pub"


aws_account_id = "288542289574"
instance_port  = 8000
