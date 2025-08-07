data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}




resource "aws_ecs_cluster" "main" {
  name = "${var.project}-ecs-cluster"
}

resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "${var.project}-ecs-launch-"
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = "t3.micro"  # or t2.micro (free tier)

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.ecs_instance_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
            EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-ecs-instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "${var.project}-ecs-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = aws_subnet.private[*].id
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.project}-ecs-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

