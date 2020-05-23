output "role_profile_name" {
  value = "${aws_iam_instance_profile.profile.name}"
  description = "Role profile name"
}

output "role_arn" {
  value = "${aws_iam_role.role.arn}"
  description = "Role arn"
}
