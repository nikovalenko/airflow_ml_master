output "address" {
  value = "${aws_db_instance.database.address}"
  description = "address"
}

output "name" {
  value = "${aws_db_instance.database.name}"
  description = "name"
}
