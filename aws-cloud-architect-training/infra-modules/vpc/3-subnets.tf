resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_blocks)


  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = merge(var.public_subnet_tags, {
    Name = "${var.env}-public-subnet-${count.index}"
  })
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.private_subnet_tags, {
    Name = "${var.env}-private-subnet-${count.index}"
  })
}
