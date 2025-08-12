resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "app_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile_name
  associate_public_ip_address = var.associate_public_ip
  key_name                    = aws_key_pair.deployer.key_name

  tags = {
    Name = var.name
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io unzip

    systemctl start docker
    systemctl enable docker

    usermod -aG docker ubuntu

    # Install AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install

    # Login to ECR and pull image
    aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.ecr_repo_url}

    docker pull ${var.ecr_repo_url}:latest
    docker stop backend || true
    docker rm backend || true
    docker run -d -p ${var.instance_port}:${var.instance_port} --restart unless-stopped --name backend ${var.ecr_repo_url}:latest
  EOF
}
