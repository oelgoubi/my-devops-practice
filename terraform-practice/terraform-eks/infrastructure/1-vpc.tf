# 65 thousand IP addresses almost 2^16
resource "aws_vpc" "compute" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "compute"
  }
}
