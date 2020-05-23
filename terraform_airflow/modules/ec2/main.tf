resource "aws_instance" "airflow_instance" {
  key_name                    = "${var.key}"
  associate_public_ip_address = true
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = [ "${aws_security_group.sec_group.id}", ]
  iam_instance_profile        = "${var.role_profile_name}"

  root_block_device {
    volume_size = 32
  }

  tags {
    Name = "${var.name}"
  }

  provisioner "file" {
    content     = "${var.content}"
    destination = "/var/tmp/airflow.cfg"

    connection {
      user        = "centos"
      agent       = false
      private_key = "${file("files/ssh/${var.key}.pem")}"
    }
  }

    provisioner "file" {
    content     = "${var.sm_connector}"
    destination = "/var/tmp/airflow_conn.py"

    connection {
      user        = "centos"
      agent       = false
      private_key = "${file("files/ssh/${var.key}.pem")}"
    }
  }



  user_data  = "${var.user_data}"
}

resource "aws_security_group" "sec_group" {
    name        = "${var.name}-sec-group"
    description = "${var.name}_sec_group"
    vpc_id      = "${var.vpc_id}"

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

//    ingress {
//        from_port       = 80
//        to_port         = 80
//        protocol        = "tcp"
//        security_groups = ["${var.alb_sg_id}"]
//        self            = false
//    }

    ingress {
      from_port         = 22
      protocol          = "tcp"
      to_port           = 22
      cidr_blocks       = ["0.0.0.0/0"]
    }

//    ingress {
//      from_port         = 80
//      to_port           = 80
//      protocol          = "tcp"
//      security_groups   = ["${var.codebuild_sg_id}"]
//    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

}
