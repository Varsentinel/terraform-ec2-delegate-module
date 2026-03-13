resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  cidr_block = var.subnet_cidr_block
  vpc_id = aws_vpc.this.id
  depends_on = [ aws_vpc.this ]
  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  depends_on = [ aws_vpc.this ]
  tags = {
    Name = var.vpc_name
  }
}


resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  depends_on = [ aws_vpc.this, aws_internet_gateway.this ]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  # r6g.large
  instance_type = var.instance_type

  tags = {
    Name = var.name
  }
}