resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.env}-public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.env}-private-route-table"
  }
}


// Associate the public route table with the public subnets
resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_subnet_cidr_blocks)
  
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

// Associate the private route table with the private subnets
resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
