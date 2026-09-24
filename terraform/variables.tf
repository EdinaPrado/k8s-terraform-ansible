variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "worker_count" {
  type    = number
  default = 2
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "control_plane_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "workers_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/k8s-lab.pub"
}

variable "my_ip_cidr" {
  type        = string
  description = "Seu IP público no formato CIDR, ex: 200.10.10.10/32"
}
variable "aluno" {
  type    = string
  default = "edina"
}
