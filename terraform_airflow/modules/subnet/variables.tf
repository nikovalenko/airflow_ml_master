variable "name" {
  type        = "string"
  description = "Name of the subnet"
}

variable "vpc_id" {
  type        = "string"
  description = "Vpc id"
}

variable "cidr" {
  type        = "string"
  description = "Cidr"
}

variable "az" {
  type        = "string"
  description = "AZ"
}

variable "map_ip" {
  type = "string"
  description = "pub or priv"
}