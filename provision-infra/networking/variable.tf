variable "vpc_cidr" {
  type = string
}

variable "prefix" {
  default = "quanghuy"
}

variable "project" {
  default = "VTI project"
}

variable "contact" {
  default = "quanghuy2451999@gmail.com"
}

variable "public_cidrs" {
    type = list
}

variable "private_cidrs" {
  type = list
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}

variable "access_ip" {
  type = string
}

variable "security_groups" {
  
}

variable "db_subnet_group" {
  type = bool
}


