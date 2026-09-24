resource "aws_vpc" "k8s" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "k8s-vpc-${var.aluno}"
  }
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name = "k8s-igw-${var.aluno}"
  }
}

resource "aws_subnet" "control_plane" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.control_plane_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-subnet-control-plane-${var.aluno}"
  }
}

resource "aws_subnet" "workers" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.workers_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-subnet-workers-${var.aluno}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }

  tags = {
    Name = "k8s-rt-public-${var.aluno}"
  }
}

resource "aws_route_table_association" "control_plane" {
  subnet_id      = aws_subnet.control_plane.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "workers" {
  subnet_id      = aws_subnet.workers.id
  route_table_id = aws_route_table.public.id
}