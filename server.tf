provider "aws" {
  region = var.region
}

#Creating the VPC
resource "aws_vpc" "my-vpc" {
  cidr_block  = var.vpc_cidr
  
  tags = {
    Name = "my-vpc"
  }
}

#Craeting Private Subnet
resource "aws_subnet" "private-sn" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.private_sn_cidr
  availability_zone = var.az

  tags = {
    Name = "Private1"
  }
}

resource "aws_subnet" "public-sn" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.public_sn
  availability_zone = var.az

  tags = {
    Name = "Public1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "rtb"
  }
}

resource "aws_route" "pub-rt" {
  route_table_id            = aws_route_table.public-route.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  depends_on                = [aws_route_table.public-route]
}

resource "aws_route_table_association" "route" {
  subnet_id      = aws_subnet.public-sn.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private-sn.id

  tags = {
    Name = "pracec2"
  }
}