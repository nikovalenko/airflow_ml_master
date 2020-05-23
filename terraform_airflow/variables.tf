variable "ami" {
  type        = "string"
  default     = "ami-0057d8e6fb0692b80"
  description = "AMI code for the Airflow server"
}

variable "instance_type" {
  type        = "string"
  default     = "m4.xlarge"
  description = "Instance type for the Airflow server"
}

variable "key" {
  type        = "string"
  default     = "ml-ops-us-east-1"
  description = "AWS SSH Key Pair name"
}

variable "fernet_key" {
  type        = "string"
  default     = "tK1mnTEm6N53V50y7Bx7-JQ-iexCq79ESmhpYUqQwoI="
  description = "Key for encrypting data in the database - see Airflow docs"
}

variable "build_compute_type" {
  type        = "string"
  default     = "BUILD_GENERAL1_SMALL"
  description = "Compute type"
}

variable "code_build_image" {
  type        = "string"
  default     = "aws/codebuild/standard:2.0-1.12.0"
  description = "Image for codebuild"
}

variable "github_location" {
  type        = "string"
  default     = "https://github.com/nikovalenko/airflow_ml_master.git"
  description = "Github location"
}

variable "buildspec" {
  type        = "string"
  default     = "terraform_airflow/files/buildspec.yml"
  description = "buildspec path"
}