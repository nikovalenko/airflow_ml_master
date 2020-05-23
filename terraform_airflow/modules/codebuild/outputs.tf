output "codebuild_sg_id" {
  value = "${aws_security_group.sec_group.id}"
  description = "Codebuild sg id"
}
