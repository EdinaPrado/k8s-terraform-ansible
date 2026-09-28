resource "aws_vpc" "k8s" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "k8s-vpc"
  }
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name = "k8s-igw"
  }
}

resource "aws_subnet" "control_plane" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.control_plane_subnet_cidr
  availability_zone       = data.aws_availability_zones.disponiveis.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-subnet-control-plane"
  }
}

resource "aws_subnet" "workers" {
  count                   = 2
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = cidrsubnet(var.workers_subnet_cidr, 1, count.index)
  availability_zone       = data.aws_availability_zones.disponiveis.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-subnet-workers-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }

  tags = {
    Name = "k8s-rt-public"
  }
}

resource "aws_route_table_association" "control_plane" {
  subnet_id      = aws_subnet.control_plane.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "workers" {
  count          = 2
  subnet_id      = aws_subnet.workers[count.index].id
  route_table_id = aws_route_table.public.id
}
