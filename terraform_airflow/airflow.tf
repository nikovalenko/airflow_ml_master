data "template_file" "airflow_user_data" {
  template = "${file("${path.module}/files/cloud_init.sh")}"
}

resource "random_id" "db_pass" {
  byte_length = 8
}

data "template_file" "sm_connector" {
  template = "${file("${path.module}/files/airflow_conn.py")}"
}


data "template_file" "airflow_config" {
  template = "${file("${path.module}/files/airflow.cfg")}"
  vars {
    fernet_key = "${var.fernet_key}"
    db_url     = "${module.airflow_rds.address}"
    db_pass    = "${random_id.db_pass.hex}"
    db_name    = "${module.airflow_rds.name}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "airflow_vpc" {
  source = "./modules/vpc"
  cidr = "173.32.0.0/16"
  name = "airflow"
  subnet_id = "${module.pub_subnet.subnet_id}"
  cb_subnet_id = "${module.priv_cb_subnet.subnet_id}"
}

module "pub_subnet" {
  source = "./modules/subnet"
  name = "pub_subnet"
  vpc_id = "${module.airflow_vpc.vpc_id}"
  cidr = "173.32.0.0/24"
  az = "${data.aws_availability_zones.available.names[0]}"
  map_ip = "true"
}

module "priv_subnet" {
  source = "./modules/subnet"
  name = "priv_subnet"
  vpc_id = "${module.airflow_vpc.vpc_id}"
  cidr = "173.32.1.0/24"
  az = "${data.aws_availability_zones.available.names[1]}"
  map_ip = "false"
}

module "priv_cb_subnet" {
  source = "./modules/subnet"
  name = "cb-subnet"
  vpc_id = "${module.airflow_vpc.vpc_id}"
  cidr = "173.32.2.0/24"
  az = "${data.aws_availability_zones.available.names[2]}"
  map_ip = "false"
}

module "airflow_role_ect" {
  source = "./modules/iamr"
  name = "ec2"
  service_name = "ec2.amazonaws.com"
}

module "airflow_rds" {
  source = "./modules/rds"
  user_name = "airflow"
  db_pass = "${random_id.db_pass.hex}"
  instance_private_ip = "${module.airflow_instance.instance_private_ip}"
  name = "rds"
  vpc_id = "${module.airflow_vpc.vpc_id}"
  subnet_ids = ["${module.pub_subnet.subnet_id}", "${module.priv_subnet.subnet_id}"]
}

module "airflow_instance" {
  source = "./modules/ec2"
  name = "airflow-ec2"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key = "${var.key}"
  vpc_id = "${module.airflow_vpc.vpc_id}"
  subnet_id = "${module.pub_subnet.subnet_id}"
  role_profile_name = "${module.airflow_role_ect.role_profile_name}"
  content = "${data.template_file.airflow_config.rendered}"
  user_data = "${data.template_file.airflow_user_data.rendered}"
  codebuild_sg_id = "${module.airflow_codebuild.codebuild_sg_id}"
  sm_connector = "${data.template_file.sm_connector.rendered}"
}

module "codebuild_role" {
  source = "./modules/iamr"
  name = "codebuild-airflow"
  service_name = "codebuild.amazonaws.com"
}

module "airflow_codebuild" {
  source = "./modules/codebuild"
  name = "airflow-cb"
  build_compute_type = "${var.build_compute_type}"
  buildspec = "${var.buildspec}"
  code_build_image = "${var.code_build_image}"
  github_location = "${var.github_location}"
  instance_public_dns = "${module.airflow_instance.instance_public_dns}"
  role_arn = "${module.codebuild_role.role_arn}"
  vpc_id = "${module.airflow_vpc.vpc_id}"
  private_subnet = "${module.priv_cb_subnet.subnet_id}"
}