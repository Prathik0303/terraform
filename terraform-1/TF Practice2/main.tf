resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[0]
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[1]
  availability_zone = "${var.aws_region}b"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[0]
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[1]
  availability_zone = "${var.aws_region}b"
}
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route" "public_subnet_route_to_internet_gateway_1" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"  
  gateway_id             = aws_internet_gateway.test_igw.id  
}
resource "aws_route" "public_subnet_route_to_internet_gateway_2" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"  
  gateway_id             = aws_internet_gateway.test_igw.id  
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id  # Assuming public_subnet_1 is the first public subnet
}

resource "aws_route" "private_subnet1_route_to_nat_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.test_vpc.id
}
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.test_vpc.id
  depends_on = [aws_subnet.public_subnet_1, aws_subnet.public_subnet_2]
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.test_vpc.id
  depends_on = [aws_subnet.private_subnet_1, aws_subnet.private_subnet_2]
}
resource "aws_network_acl_rule" "public_nacl_allow_ssh" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  protocol       = "6"  # TCP
  from_port      = 22
  to_port        = 22
  cidr_block     = var.ssh_cidr_block
}

resource "aws_network_acl_rule" "private_nacl_allow_ssh" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  protocol       = "6"  # TCP
  from_port      = 22
  to_port        = 22
  cidr_block     = var.ssh_cidr_block
}

resource "aws_network_acl_association" "public_nacl_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_nacl_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "private_nacl_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  network_acl_id = aws_network_acl.private_nacl.id
}

resource "aws_network_acl_association" "private_nacl_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  network_acl_id = aws_network_acl.private_nacl.id
}
resource "aws_s3_bucket" "prathik99_bucket" {
  bucket = "prathik99"
  acl    = "private"
}