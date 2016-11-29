provider "aws" {
  region  = "us-east-1"
  profile = "terraform_wildwest"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "bp_example_vpc"
  }
}

resource "aws_subnet" "subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = "${aws_vpc.example_vpc.id}"
  availability_zone = "us-east-1a"
  tags {
    Name = "bp_example_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.example_vpc.id}"
  tags {
    Name = "bp_example_igw"
  }
}

resource "aws_route" "route" {
  route_table_id         = "${aws_vpc.example_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route.route.id}"
}

/* resource "aws_instance" "example" {
  ami           = "ami-2d39803a"
  instance_type = "t2.micro"
} */
