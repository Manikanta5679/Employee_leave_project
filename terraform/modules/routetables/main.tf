resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = { Name = "${var.project}-igw" }
}

resource "aws_eip" "nat" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"
  tags   = { Name = "${var.project}-nat-eip-${count.index + 1}" }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(var.public_subnet_ids, count.index)
  tags          = { Name = "${var.project}-nat-${count.index + 1}" }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags   = { Name = "${var.project}-public-rt" }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = element(var.public_subnet_ids, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags   = { Name = "${var.project}-private-rt" }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = element(var.private_subnet_ids, count.index)
  route_table_id = aws_route_table.private.id
}
