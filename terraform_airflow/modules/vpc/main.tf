resource "aws_vpc" "vpc" {
    cidr_block           = "${var.cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags {
        Name = "${var.name}"
    }
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "${var.name}-gateway"
    }
}

resource "aws_route_table" "route_table" {
    vpc_id     = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }

    tags {
        Name = "${var.name}-route-table"
    }
}

resource "aws_route_table" "route_table_nat" {
    vpc_id     = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.gw.id}"
    }

    tags {
        Name = "${var.name}-nat-route-table"
    }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = "${var.subnet_id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

resource "aws_route_table_association" "cb_rt_association" {
  subnet_id = "${var.cb_subnet_id}"
  route_table_id = "${aws_route_table.route_table_nat.id}"
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${var.subnet_id}"
  depends_on = ["aws_internet_gateway.gateway"]

  tags = {
    Name = "NAT gateway"
  }
}

resource "aws_eip" "nat" {
    vpc = true
}