# Create an Elastic IP for NAT Gateway
resource "aws_eip" "nat1" {
  domain     = var.domain
  depends_on = [aws_internet_gateway.igw]


}

resource "aws_eip" "nat2" {
  domain     = var.domain
  depends_on = [aws_internet_gateway.igw]


}
