output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
  description = "Vpc id"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
  description = "Vpc cidr"
}

output "vpc_igw" {
  value = "${aws_internet_gateway.gateway.id}"
  description = "igw"
}