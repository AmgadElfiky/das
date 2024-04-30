# VPC
resource "aws_vpc" "my-vpc" {
  cidr_block                       = var.cidr_block_vpc 
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false


  tags = {
    Name = "my-vpc"
  }
}