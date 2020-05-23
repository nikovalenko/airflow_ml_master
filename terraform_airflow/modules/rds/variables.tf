variable "name" {
  type        = "string"
  description = "Name of the rds"
}

variable "db_pass" {
  type        = "string"
  description = "db pass"
}

variable "user_name" {
  type        = "string"
  description = "user name"
}

variable "subnet_ids" {
  type        = "list"
  description = "subnet_ids"
}

variable "vpc_id" {
  type        = "string"
  description = "Vpc id"
}

variable "instance_private_ip" {
  type        = "string"
  description = "Instance private ip"
}