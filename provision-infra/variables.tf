variable "aws_region" {
  default = "ap-northeast-1"
}

variable "access_ip" {
  type = string
}

#-------database variables

variable "dbname" {
  type = string
}
variable "dbuser" {
  type = string
}
variable "dbpassword" {
  type      = string
  sensitive = true
}

