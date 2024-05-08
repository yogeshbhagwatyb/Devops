###VPC###
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc-tag
  }
}

###Public Subnet###
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-subnet-cidr 
  map_public_ip_on_launch = true

  tags = {
    Name = var.Public-Subnet-tag
  }
}

###Internet Gateway###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.EzDevops-VPC.id

  tags = {
    Name = var.IGW-tag
  }
}

###Public Route Table###
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

###Public Route Table Association###
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

###Private Subnet###
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet-cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.private-subnet-tag
  }
}


###Private Route Table###
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = var.private-subnet-tag
  }
}

###Private Route Table Association###
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

###AWS Key Pair###
resource "tls_private_key" "my_private_key" {
  algorithm   = "RSA"
  rsa_bits    = 2048
}

###AWS Key Pair###
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-keypair"  # Specify the name of your key pair
  public_key = tls_private_key.my_private_key.public_key_openssh
}

###AWS Key Pair###
resource "local_file" "private_key_file" {
  content  = tls_private_key.my_private_key.private_key_pem
  filename = "./"  # Specify the desired location for the private key
}

###EC2 Instance###
resource "aws_instance" "my_ec2_instance" {
  ami             = data.aws_ami.ubuntu.id  # Specify the AMI ID of the instance
  instance_type   = var.instance-type  # Specify the instance type
  key_name        = aws_key_pair.my_key_pair.key_name  # Use the key pair generated above

  subnet_id       = aws_subnet.public_subnet.id  # Use the subnet ID where you want to launch the instance
  security_groups = [aws_security_group.my_security_group.name]  # Specify the security group(s) for the instance

  tags = {
    Name = var.instance-tag
  }
}
