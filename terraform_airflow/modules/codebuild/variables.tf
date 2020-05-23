variable "name" {
  type        = "string"
  description = "codebuild name"
}

variable "role_arn" {
  type        = "string"
  description = "Role arn"
}

variable "build_compute_type" {
  type        = "string"
  description = "Compute type"
}

variable "code_build_image" {
  type        = "string"
  description = "Image for codebuild"
}

variable "github_location" {
  type        = "string"
  description = "Github location"
}

variable "instance_public_dns" {
  type        = "string"
  description = "Instance public dns"
}

variable "buildspec" {
  type        = "string"
  description = "Buildspec"
}

variable "vpc_id" {
  type        = "string"
  description = "Vpc id"
}

variable "private_subnet" {
  type        = "string"
  description = "subnet_id"
}