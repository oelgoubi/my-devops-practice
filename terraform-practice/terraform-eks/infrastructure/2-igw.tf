# Attach an internet gateway to the VPC to be able to access the internet (In and Out)
# it will be used as a default route in public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.compute.id

  tags = {
    Name = "compute-igw"
  }
}