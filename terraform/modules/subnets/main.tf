resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)
  tags                    = { Name = "${var.project}-public-${count.index + 1}" }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = element(var.azs, count.index)
  tags                    = { Name = "${var.project}-private-${count.index + 1}" }
}
