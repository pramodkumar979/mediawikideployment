# Create VPC 
resource "aws_vpc" "mediawiki_vpc" {
  cidr_block           = var.cidr_blocks[0]
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name        = "${var.projectName}-vpc"
  }
}

# Create Internet Gateways and attached to VPC.
resource "aws_internet_gateway" "mediawiki_ig" {
  vpc_id = aws_vpc.mediawiki_vpc.id

  tags = {
    Name        = "${var.projectName}-igw"
  }
}

#Create public subnet-1 
resource "aws_subnet" "mediawiki_pub_sub_1" {
  vpc_id            = aws_vpc.mediawiki_vpc.id
  availability_zone = var.availablity_zones[0]
  cidr_block        = var.cidr_blocks[1]

  tags = {
    Name        = "${var.projectName}-pub-sub1"
  }
}

#Create private subnet-1
resource "aws_subnet" "mediawiki_pri_sub_1" {
  vpc_id            = aws_vpc.mediawiki_vpc.id
  availability_zone = var.availablity_zones[0]
  cidr_block        = var.cidr_blocks[2]

  tags = {
    Name        = "${var.projectName}-pri-sub1"
  }
}

#Create private subnet-2
resource "aws_subnet" "mediawiki_pri_sub_2" {
  vpc_id            = aws_vpc.mediawiki_vpc.id
  availability_zone = var.availablity_zones[1]
  cidr_block        = var.cidr_blocks[3]

  tags = {
    Name        = "${var.projectName}-pri-sub2"
  }
}

# Subnet association between a route table and a private subnet1
resource "aws_route_table_association" "mediawiki_pri_sub_a" {
  subnet_id      = aws_subnet.mediawiki_pri_sub_1.id
  route_table_id = aws_route_table.mediawiki_private_rt.id
}

# Subnet association between a route table and a private subnet2
resource "aws_route_table_association" "mediawiki_pri_sub_b" {
  subnet_id      = aws_subnet.mediawiki_pri_sub_2.id
  route_table_id = aws_route_table.mediawiki_private_rt.id
}

# Subnet association between a route table and a public subnet
resource "aws_route_table_association" "mediawiki_pub_sub_a" {
  subnet_id      = aws_subnet.mediawiki_pub_sub_1.id
  route_table_id = aws_default_route_table.mediawiki_default_rt.id
}


##Create Elastic IP for NAT Gateway
resource "aws_eip" "mediawiki_elastic-ip" {
  domain   = "vpc"
  associate_with_private_ip = var.elastic-private-ip-range

  tags = {
    Name        = "${var.projectName}-ngw-elastic-ip"
    Description = "Elastic IP for NAT Gateway"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "mediawiki_nat_gateway" {
  allocation_id = aws_eip.mediawiki_elastic-ip.id
  subnet_id     = aws_subnet.mediawiki_pub_sub_1.id

  tags = {
    Name        = "${var.projectName}-ngw"
  }
}

#Manage a default route table of a VPC (Public Route Table)
resource "aws_default_route_table" "mediawiki_default_rt" {
  default_route_table_id = aws_vpc.mediawiki_vpc.default_route_table_id

  route {
    cidr_block = var.destination-cidr-block
    gateway_id = aws_internet_gateway.mediawiki_ig.id
  }
  tags = {
    Name        = "${var.projectName}-public-rt"
  }
}

#Create Private Route table
resource "aws_route_table" "mediawiki_private_rt" {
  vpc_id = aws_vpc.mediawiki_vpc.id

  route {
    cidr_block     = var.destination-cidr-block
    nat_gateway_id = aws_nat_gateway.mediawiki_nat_gateway.id
  }
  tags = {
    Name        = "${var.projectName}-private-rt"
  }
}