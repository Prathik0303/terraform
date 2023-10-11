  terraform {
  backend "s3" {
    bucket = "prathik99"
    key    = "home/ec2-user/terraform.tfstate"
    region = "us-east-1"
  }
}