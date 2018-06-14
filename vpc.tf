resource "aws_vpc" "main-vpc" {
  cidr_block                       = "${var.cidr}"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags                             = {
    Name        = "${var.environment}"
  }
}

resource "aws_internet_gateway" "main-gateway" {
  vpc_id = "${aws_vpc.main-vpc.id}"
  tags   = {
    Name        = "${var.environment}"
  }
}

resource "aws_default_route_table" "main-route-table" {
  default_route_table_id = "${aws_vpc.main-vpc.default_route_table_id}"
  tags   = {
    Name        = "${var.environment}-default"
  }
}

resource "aws_route" "ipv4-default-gateway" {
  route_table_id         = "${aws_default_route_table.main-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main-gateway.id}"
}

/******************************************************************************************************/

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "consul" {
  vpc_id                          = "${aws_vpc.main-vpc.id}"
  cidr_block                      = "${var.cidr}"
  availability_zone               = "${data.aws_availability_zones.available.names[0]}"
  tags                            = {
    Name        = "${var.environment}"
  }
}