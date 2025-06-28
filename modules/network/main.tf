resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "poc-${var.env}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone = "eu-west-1a"

  tags = {
    Name = "poc-${var.env}-subnet${count.index + 1}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "poc-${var.env}-igw"
  }
}
