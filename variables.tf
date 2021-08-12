# variables.tf

variable "module_depends_on" {
  type    = list(any)
  default = []
}

variable "namespace" {
  type    = string
  default = "cert-manager"
}

variable "cluster_name" {
  type    = string
  default = ""
}

variable "domains" {
  type    = list(string)
  default = []
}

variable "email" {
  type    = string
  default = ""
}

variable "zone_id" {
  type = string
}

variable "project" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
}
