resource "aws_codebuild_project" "build" {
  name          = "${var.name}"
  description   = "The CodeBuild ${var.name} project"
  service_role = "${var.role_arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "${var.build_compute_type}"
    image           = "${var.code_build_image}"
    type            = "LINUX_CONTAINER"
    privileged_mode = "false"

    environment_variable {
      name          ="AIRFLOW_INSTANCE_PUBLIC_DNS",
      value         ="${var.instance_public_dns}"
    }
  }

  source {
    type            = "GITHUB"
    location        = "${var.github_location}"
    git_clone_depth = 1
    buildspec       = "${var.buildspec}"

    auth {
      type     = "OAUTH"
    }
  }

   vpc_config {
    vpc_id = "${var.vpc_id}"

    subnets = [
      "${var.private_subnet}",
    ]

    security_group_ids = [
      "${aws_security_group.sec_group.id}",
    ]
  }
}

resource "aws_security_group" "sec_group" {
    name        = "${var.name}-sec-group"
    description = "${var.name}_sec_group"
    vpc_id      = "${var.vpc_id}"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

}
