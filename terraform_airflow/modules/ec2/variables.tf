variable "name" {
  type        = "string"
  description = "Name of the ec2"
}

variable "key" {
  type        = "string"
  description = "AWS SSH Key Pair name"
}

variable "ami" {
  type        = "string"
  description = "AMI code of the server"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type of the server"
}

variable "subnet_id" {
  type        = "string"
  description = "Instanse subnet id"
}

//variable "alb_sg_id" {
//  type        = "string"
//  description = "Alb sg id"
//}

variable "vpc_id" {
  type        = "string"
  description = "Vpc id"
}

variable "role_profile_name" {
  type        = "string"
  description = "Role profile name"
}

variable "content" {
  type        = "string"
  description = "Server content"
}

variable "sm_connector" {
  type        = "string"
  description = "SageMaker connector"
}

variable "user_data" {
  type        = "string"
  description = "Server userdata"
}

variable "codebuild_sg_id" {
  type        = "string"
  description = "Codebuild sg"
}
