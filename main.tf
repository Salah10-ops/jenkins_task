provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "cicd" {
  ami           = "ami-04b4f1a9cf54c11d0"  
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = aws_subnet.main_subnet.id  
  vpc_security_group_ids = [aws_security_group.cicd_sg.id] 

  tags = {
    Name = "CICD-Machine"
  }
}

resource "aws_instance" "prod" {
  ami           = "ami-04b4f1a9cf54c11d0"  
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = aws_subnet.main_subnet.id  
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  tags = {
    Name = "Production-Machine"
  }
}

resource "aws_security_group" "cicd_sg" {

  vpc_id = aws_vpc.main_vpc.id
  description = "Allow SSH & Jenkins"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  tags = {
    Name = "cicd-sg"
  }
}

resource "aws_security_group" "prod_sg" {
  vpc_id = aws_vpc.main_vpc.id
  description = "Allow SSH & Web Traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-sg"
  }
}


resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MainVPC"
  }
}


resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" 
  tags = {
    Name = "MainSubnet"
  }
}




