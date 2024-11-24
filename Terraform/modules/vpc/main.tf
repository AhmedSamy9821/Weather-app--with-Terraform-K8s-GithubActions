##############
#vpc module creates vpc and 4 public subnets for eks cluster
############## 

resource "aws_vpc" "k8s_dev_vpc" {
  cidr_block = var.vpc_cider
   tags = {
    env = var.env
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "k8s_dev-igw" {
  vpc_id = aws_vpc.k8s_dev_vpc.id

  tags = {
    Name = "${var.env}-k8s_dev-igw"
    env = var.env
  }
}


resource "aws_route_table" "k8s_dev_rt" {
  vpc_id = aws_vpc.k8s_dev_vpc.id

  route {
    cidr_block = var.vpc_cider
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_dev-igw.id
  }

  tags = {
    env = var.env
    Name = "${var.env}-k8s_dev_rt"
  }
}

resource "aws_subnet" "dev_subnet" {
    vpc_id     = aws_vpc.k8s_dev_vpc.id
    map_public_ip_on_launch = true
    count      = length(var.subnet_cidrs)
    cidr_block = var.subnet_cidrs[count.index]

  tags = {
    env = var.env
    Name = "${var.env}-public-subnet${count.index}"
  }
}

resource "aws_route_table_association" "k8s_dev" {
  count      = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.dev_subnet[count.index].id
  route_table_id = aws_route_table.k8s_dev_rt.id
  
}