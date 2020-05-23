variable "name" {
  type        = "string"
  description = "Name of the project"
}

variable "subnet_id" {
  type        = "string"
  description = "Subnet id"
}

variable "cidr" {
  type        = "string"
  description = "Cidr"
}

variable "cb_subnet_id" {
  type        = "string"
  description = "CB subnet id"
}
