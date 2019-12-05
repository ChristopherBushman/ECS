provider "aws" {
	region = "us-west-2"
}

data "aws_availability_zones" "available" {}

#VPC Creation
resource "aws_vpc" "mainvpc" {
	cidr_block = "10.0.0.0/20"
	enable_dns_hostnames = true
	enable_dns_support = true

	tags = {
		Name = "CIT480"
	}
}

#Create Internet Gateway
resource "aws_internet_gateway" "gw" {
	vpc_id = "${aws_vpc.mainvpc.id}"
}

#Create public route table
resource "aws_route_table" "public_route" {
	vpc_id = "${aws_vpc.mainvpc.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.gw.id}"
	}

	tags = {
		Name = "my-public-route-table"
	}
}

#Public subnet
resource "aws_subnet" "public_subnet" {
	vpc_id = "${aws_vpc.mainvpc.id}"
	cidr_block = "10.0.1.0/24"

	tags = {
		Name = "Main"
	}
}

#Security Group ElastiSearch
resource "aws_security_group" "ElastiSearch" {
  name        = "ElastiSearch"
  description = "Allow inbound traffic for ElastiSearch"
  vpc_id      = "${aws_vpc.mainvpc.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]# add a CIDR block here
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

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  ingress {
    from_port	= 9300
    to_port	= 9300
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#Security Group Kibana
resource "aws_security_group" "Kibana" {
  name        = "Kibana"
  description = "Allow inbound traffic for Kibana"
  vpc_id      = "${aws_vpc.mainvpc.id}"

  ingress {
    # TLS (change to whatever ports you need)
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

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  ingress {
    from_port	= 5044
    to_port	= 5044
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
