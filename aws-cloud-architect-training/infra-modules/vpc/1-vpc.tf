resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  # Enable DNS support and DNS hostnames
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

