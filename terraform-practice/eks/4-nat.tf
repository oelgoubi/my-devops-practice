#####
### NAT Gateway : it's used in private subnets to allow the instances to access the internet
### it stands for Network Address Translation Gateway
######



# Allopcate an Elastic Public IP for the NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

# Create a NAT Gateway in the public subnet created previously and wait for the IGW to be created
# Because subnet must have IGW as a defalut route
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}