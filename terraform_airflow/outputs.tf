
output "airflow_instance_public_dns" {
  value       = "${module.airflow_instance.instance_public_dns}"
  description = "Public DNS for the Airflow instance"
}

output "ec2_sec_group_id" {
  value      = "${module.airflow_instance.ec2_secgroup_id}"
  description = "EC2 sec group"
}

output "cb_sec_group_id" {
  value      = "${module.airflow_codebuild.codebuild_sg_id}"
  description = "Cb sec group"
}