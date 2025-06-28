

resource "aws_security_group" "this" {
  name        = "poc-${var.env}-sg"
  vpc_id      = var.vpc_id
  description = "Allow SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "poc-${var.env}-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "this" {
  count         = var.instance_count
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = element(var.subnet_ids, count.index)
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = "poc-${var.env}-instance${count.index + 1}"
  }
}
