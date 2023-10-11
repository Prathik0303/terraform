provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Test1" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
}

resource "aws_ebs_volume" "Test-volume" {
  availability_zone = "${aws_instance.Test1.availability_zone}"
  size              = 8
}

resource "aws_security_group" "Test-sg" {
  vpc_id = "vpc-008013e9522c4f3b5"

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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Test" {
  ami                    = "ami-0c94855ba95c71c99"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Test-sg.id]
}
resource "aws_s3_bucket" "prathik99_bucket" {
  bucket = "prathik99"
  acl    = "private"
}

 resource "aws_iam_role" "Test_role" {
  name = "Test-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "Test_policy" {
  name        = "Test-s3-policy"
  description = "Allows access to S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource  = [
          "arn:aws:s3:::prathik99",
          "arn:aws:s3:::prathik99/*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "Test_policy_attachment" {
  role       = aws_iam_role.Test_role.name
  policy_arn = aws_iam_policy.Test_policy.arn
}


  resource "aws_iam_instance_profile" "Test1" {
    name  = "Test1-instance-profile"
    role  = aws_iam_role.Test_role.name
  }

  resource "aws_instance" "Test2" {
    ami                    = "ami-0c94855ba95c71c99"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.Test-sg.id]
    iam_instance_profile   = aws_iam_instance_profile.Test1.name
  }

  terraform {
  backend "s3" {
    bucket = "prathik99"
    key    = "home/ec2-user/terraform.tfstate"
    region = "us-east-1"
  }
}