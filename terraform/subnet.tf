# public subnet1
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.cidr_block_pub1
  map_public_ip_on_launch = true
  availability_zone       = var.AZa

  tags = {
    Name                        = "public_subnet1"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}
# public subnet2
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.cidr_block_pub2
  map_public_ip_on_launch = true
  availability_zone       = var.AZb

  tags = {
    Name                        = "public_subnet2"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}

# private subnet1
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.cidr_block_pri1
  availability_zone = "us-east-1a"

  tags = {
    Name                              = "private_subnet1"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1

  }
}
# private subnet2
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.cidr_block_pri2
  availability_zone = "us-east-1b"

  tags = {
    Name                              = "private_subnet2"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1

  }
}