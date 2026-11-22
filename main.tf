# --------------------------------------------------
# 1. Find the latest Amazon Linux 2023 AMI
# --------------------------------------------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# --------------------------------------------------
# 2. Get the existing subnet
# --------------------------------------------------

data "aws_subnet" "existing_subnet" {
  id = "subnet-083e0750068e7f301"
}


# --------------------------------------------------
# 3. Create Security Group
# --------------------------------------------------

resource "aws_security_group" "web_sg" {
  name        = "terraform-web-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = data.aws_subnet.existing_subnet.vpc_id

  # SSH access
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["103.5.135.50/32"]
  }

  # HTTP access
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Web-Security-Group"
  }
}


# --------------------------------------------------
# 4. Create EC2 Instance
# --------------------------------------------------

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.existing_subnet.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = file("userdata.sh")

  tags = {
    Name = var.instance_name
  }
}