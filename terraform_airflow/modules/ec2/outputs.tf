output "instance_id" {
  value = "${aws_instance.airflow_instance.id}"
  description = "Instance id"
}

output "instance_private_ip" {
  value = "${aws_instance.airflow_instance.private_ip}"
  description = "Instance privat ip"
}

output "instance_public_dns" {
  value = "${aws_instance.airflow_instance.public_dns}"
  description = "Instance public dns"
}

output "ec2_secgroup_id" {
  value = "${aws_security_group.sec_group.id}"
  description = "EC2 secgroup id"
}