# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "landing-zone-vpc"
  }
}
resource "aws_subnet" "mysubnet_a" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "landing-zone-subnet1"
  }
}
resource "aws_subnet" "mysubnet_b" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "landing-zone-subnet2"
  }
}

resource "aws_network_interface" "networkInterface" {
  subnet_id   = aws_subnet.mysubnet_a.id
  private_ips = ["10.0.1.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "awsinstance" {
  ami           = "ami-097855b862d5b1eb2"
  instance_type = "t2.micro"

  primary_network_interface {
    network_interface_id = aws_network_interface.networkInterface.id

  }
  depends_on = [aws_internet_gateway.internetgateaway]
}

resource "aws_internet_gateway" "internetgateaway" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "landing-zone-igw"
  }
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgateaway.id
  }

  tags = {
    Name = "landing-zone-rt"
  }
}

resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.mysubnet_a.id
  route_table_id = aws_route_table.routetable.id
}
resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.mysubnet_b.id
  route_table_id = aws_route_table.routetable.id
}
