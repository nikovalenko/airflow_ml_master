resource "aws_db_instance" "database" {
  identifier                = "database-${var.name}"
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "9.6.6"
  instance_class            = "db.t2.small"
  name                      = "${var.name}"
  username                  = "${var.user_name}"
  password                  = "${var.db_pass}"
  storage_type              = "gp2"
  backup_retention_period   = 14
  multi_az                  = false
  publicly_accessible       = false
  apply_immediately         = true
  db_subnet_group_name      = "${aws_db_subnet_group.subnetgroup.name}"
  skip_final_snapshot       = true
  vpc_security_group_ids    = [ "${aws_security_group.allow_database.id}"]
  port                      = "5432"
}

resource "aws_db_subnet_group" "subnetgroup" {
  name        = "database-subnetgroup_${var.name}"
  description = "database subnet group"
  subnet_ids  = ["${var.subnet_ids[0]}", "${var.subnet_ids[1]}"]
}

resource "aws_security_group" "allow_database" {
  name        = "allow_database_${var.name}"
  description = "Controlling traffic to and from rds instance."
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
}

resource "aws_security_group_rule" "allow_database_rule" {
  security_group_id = "${aws_security_group.allow_database.id}"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"

  cidr_blocks = [
    "${var.instance_private_ip}/32"
  ]
}
