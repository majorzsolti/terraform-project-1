# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = 
  secret_key = 
}

# resource "aws_instance" "myUbuntuServer" {
#   ami = "ami-04a81a99f5ec58529"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "Ubuntu"
#   }
# }

    # resource "aws_vpc" "myFirstVPC" {
    #   cidr_block = "10.0.0.0/16"

    #   tags = {
    #     Name = "MyTestVPC"
    #     }   
    # }

    # resource "aws_subnet" "myFirstSubnet" {
    #   vpc_id = aws_vpc.myFirstVPC.id
    #   cidr_block = "10.0.1.0/24"

    #     tags = {
    #     Name = "prod-subnet"
    #     } 
    # }

# Lets create a custom web based solution 
#* 1. Create the VPC

resource "aws_vpc" "prod-vpc-project" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Prod"
    }   
}

#* 2. Create an internet gateway

resource "aws_internet_gateway" "prod-gateway" {
  vpc_id = aws_vpc.prod-vpc-project.id

  tags = {
    Name = "Prod"
  }
}

#* 3. Create custom route table 
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc-project.id

  route {
    cidr_block = "0.0.0.0/0" #default gateway (All trafic is sent to the internet gateway)
    gateway_id = aws_internet_gateway.prod-gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.prod-gateway.id
  }

  tags = {
    Name = "Prod"
  }
}

#* 4. Create a subnet

resource "aws_subnet" "subnet-prod" {
  vpc_id = aws_vpc.prod-vpc-project.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

    tags = {
      Name = "prod-subnet"
    } 

}

#* 5. Associate the route table with the subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-prod.id
  route_table_id = aws_route_table.prod-route-table.id
}

#* 6. Create a security group 
    #! This seems to be the old solution, now I switched it up with the new system found here: 
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
    # resource "aws_security_group" "allow_web" {
    #   name        = "allow_web_traffic"
    #   description = "Allow web inbound traffic"
    #   vpc_id      = aws_vpc.prod-vpc-project.id

    #   ingress = {
    #     description = "HTTPS"
    #     from_port = 443
    #     to_port = 443
    #     protocol = "tcp"
    #     cidr_block = "0.0.0.0/0"
    #   }

    #   ingress = {
    #     description = "HTTP"
    #     from_port = 80
    #     to_port = 80
    #     protocol = "tcp"
    #     cidr_block = "0.0.0.0/0"
    #   }

    #   ingress = {
    #     description = "SSH"
    #     from_port = 22
    #     to_port = 22
    #     protocol = "tcp"
    #     cidr_block = ["0.0.0.0/0"]
    #   }

    #   egress = {
    #     from_port = 0
    #     to_port = 0
    #     protocol = "-1"
    #     cidr_block = ["0.0.0.0/0"]
    #   }

    #   tags = {
    #     Name = "allow_web"
    #   }
    # }

            # resource "aws_security_group" "allow_web" {
            #   name        = "allow_web_traffic"
            #   description = "Allow web inbound traffic"
            #   vpc_id      = aws_vpc.prod-vpc-project.id
            #   tags = {
            #     Name = "allow_web"
            #   }
            # }

            # resource "aws_vpc_security_group_ingress_rule" "ingress_https" {
            #   security_group_id = aws_security_group.allow_web.id

            #   cidr_ipv4   = "0.0.0.0/0"
            #   from_port   = 443
            #   ip_protocol = "tcp"
            #   to_port     = 443
            # }

            # resource "aws_vpc_security_group_ingress_rule" "ingress_http" {
            #   security_group_id = aws_security_group.allow_web.id

            #   cidr_ipv4   = "0.0.0.0/0"
            #   from_port   = 80
            #   ip_protocol = "tcp"
            #   to_port     = 80
            # }

            # resource "aws_vpc_security_group_ingress_rule" "ingress_ssh" {
            #   security_group_id = aws_security_group.allow_web.id

            #   cidr_ipv4   = "0.0.0.0/0"
            #   from_port   = 22
            #   ip_protocol = "tcp"
            #   to_port     = 22
            # }

            # resource "aws_vpc_security_group_egress_rule" "egress" {
            #   security_group_id = aws_security_group.allow_web.id

            #   cidr_ipv4   = "0.0.0.0/0"
            #   from_port   = 0
            #   ip_protocol = "tcp"
            #   to_port     = 0
            # }

            # resource "aws_vpc_security_group_egress_rule" "egress-https" {
            #   security_group_id = aws_security_group.allow_web.id

            #   cidr_ipv4   = "0.0.0.0/0"
            #   from_port   = 443
            #   ip_protocol = "tcp"
            #   to_port     = 443
            # }

            # resource "aws_vpc_security_group_egress_rule" "egress-http" {
            #   security_group_id = aws_security_group.allow_web.id

            #   cidr_ipv4   = "0.0.0.0/0"
            #   from_port   = 80
            #   ip_protocol = "tcp"
            #   to_port     = 80
            # }

            # resource "aws_vpc_security_group_egress_rule" "egress-ssh" {
            #   security_group_id = aws_security_group.allow_web.id

            #   cidr_ipv4   = "0.0.0.0/0"
            #   from_port   = 22
            #   ip_protocol = "tcp"
            #   to_port     = 22
            # }


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.prod-vpc-project.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#* 7. Network interface
resource "aws_network_interface" "web-server-zsolt" {
  subnet_id       = aws_subnet.subnet-prod.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_tls.id]

  # attachment {
  #   instance     = aws_instance.test.id
  #   device_index = 1
  # }
}

#* 8. Assign an elastic IP to the network 
resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.web-server-zsolt.id
  associate_with_private_ip = "10.0.1.50"
  #Here we want the whole object, not the ID
  depends_on = [aws_internet_gateway.prod-gateway] 
}
# this require the internet gateway. And here terraform cannot really figure it out. 
# On the website it says: 
# "EIP may require IGW to exist prior to association. Use depends_on to set an explicit dependency on the IGW.""

#* 9. Create the Ubuntu server
resource "aws_instance" "web-server-instance" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  # availability_zone = "us-east-1"
  key_name = "AccessKeyTerraformProject1"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-zsolt.id
  }

  #Telling terrafrom to run some commands
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server > /var/www/html/index.html'
              EOF

  tags = {
    Name = "web-server"
  }
}