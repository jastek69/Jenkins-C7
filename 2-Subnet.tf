# SUBNETS and ROUTE TABLES

#####################################################################################################
# CALIFORNIA SUBNETS and ROUTE TABLES

resource "aws_subnet" "CA_SUBNET" {
  vpc_id     = aws_vpc.CA-VPC-Jenkins.id
  cidr_block = "10.244.0.0/24"
  availability_zone = "us-west-1a"
  tags = {
    Name = "CA_SUBNET"
    Service = "application1"
    Owner   = "Galactus"
    Planet  = "Taa"
  }
}


resource "aws_subnet" "cali-public-us-west-1a" {     
  vpc_id                  = aws_vpc.CA-VPC-Jenkins.id
  cidr_block              = "10.244.1.0/24"
  availability_zone       = "us-west-1a"
  #map_public_ip_on_launch = true

  tags = {
    Name    = "cali-public-us-west-1a"
    Service = "application1"
    Owner   = "Galactus"
    Planet  = "Taa"
  }
}


resource "aws_subnet" "cali-public-us-west-1b" {    
  vpc_id                  = aws_vpc.CA-VPC-Jenkins.id
  cidr_block              = "10.244.2.0/24"
  availability_zone       = "us-west-1b"
  #map_public_ip_on_launch = true

  tags = {
    Name    = "cali-public-us-west-1b"
    Service = "application1"
    Owner   = "Galactus"
    Planet  = "Taa"
  }
}


#these are for private
resource "aws_subnet" "cali-private-us-west-1a" {  
  vpc_id            = aws_vpc.CA-VPC-Jenkins.id
  cidr_block        = "10.244.11.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name    = "cali-private-us-west-1a"
    Service = "application1"
    Owner   = "Galactus"
    Planet  = "Taa"
  }
}


resource "aws_subnet" "cali-private-us-west-1b" {  
  vpc_id            = aws_vpc.CA-VPC-Jenkins.id
  cidr_block        = "10.244.12.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name    = "cali-private-us-west-1b"
    Service = "application1"
    Owner   = "Galactus"
    Planet  = "Taa"
  }
}


resource "aws_internet_gateway" "CA_IGW" {     # Internet Gateway ID: aws_internet_gateway.CA_IGW.id
  vpc_id     = aws_vpc.CA-VPC-Jenkins.id

  tags = {
    Name = "CA_IGW"
  }
}




# CALIFORNIA Public Route Table
resource "aws_route_table" "cali_public_rt" {   # Route Table ID: aws_route_table.cali-public-us-west-1a.id
  vpc_id = aws_vpc.CA-VPC-Jenkins.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CA_IGW.id
    }

  tags = {
    Name = "cali-public-rt"
  }
}

# Associate both public subnets
resource "aws_route_table_association" "cali_public_a" {
  subnet_id      = aws_subnet.cali-public-us-west-1a.id
  route_table_id = aws_route_table.cali_public_rt.id
}

resource "aws_route_table_association" "cali_public_b" {
  subnet_id      = aws_subnet.cali-public-us-west-1b.id
  route_table_id = aws_route_table.cali_public_rt.id
}
