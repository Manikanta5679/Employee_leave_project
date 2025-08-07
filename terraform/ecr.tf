resource "aws_ecr_repository" "backend" {
  name                 = "${var.project}-backend"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "${var.project}-backend"
  }
}
