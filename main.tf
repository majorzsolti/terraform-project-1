# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIATCKASC4KMC4VIGC7"
  secret_key = "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"
}

# resource "aws_instance" "myUbuntuServer" {
#   ami = "ami-04a81a99f5ec58529"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "Ubuntu"
#   }
# }

resource "aws_vpc" "myFirstVPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyTestVPC"
    }   
}

resource "aws_subnet" "myFirstSubnet" {
  vpc_id = aws_vpc.myFirstVPC.id
  cidr_block = "10.0.1.0/24"

    tags = {
    Name = "prod-subnet"
    } 
}