resource "aws_vpc" "this" {
  #checkov:skip=CKV2_AWS_11: AWS VPC Flow Logs not enabled
  #checkov:skip=CKV2_AWS_12: Ensure the default security group of every VPC restricts all traffic
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  cidr_block = var.subnet_cidr_block
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_vpc.this]
  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_vpc.this]
  tags = {
    Name = var.vpc_name
  }
}


resource "aws_route_table" "this" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_vpc.this, aws_internet_gateway.this]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table_association" "this" {
  route_table_id = aws_route_table.this.id
  subnet_id      = aws_subnet.public.id
  depends_on     = [aws_route_table.this, aws_subnet.public]
}

resource "aws_security_group" "this" {
  vpc_id      = aws_vpc.this.id
  description = "Allow HTTPS to Harness Delete EC2 Instance"
  #checkov:skip=CKV_AWS_382: AWS Security Group allows unrestricted egress traffic
  ingress {
    description = "Default"
    protocol    = "-1"
    self        = true
    from_port   = 0
    to_port     = 0
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.this]
}

resource "aws_instance" "this" {
  #checkov:skip=CKV_AWS_135: Ensure that EC2 is EBS optimized
  #checkov:skip=CKV_AWS_88: EC2 instance should not have public IP.
  #checkov:skip=CKV_AWS_126: Ensure that detailed monitoring is enabled for EC2 instances
  iam_instance_profile        = aws_iam_instance_profile.this.name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  root_block_device {
    encrypted             = true
    delete_on_termination = true
    volume_size           = var.volume_size
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags       = var.tags
  depends_on = [aws_security_group.this, aws_iam_instance_profile.this]
}