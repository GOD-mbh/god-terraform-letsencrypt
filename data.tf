# data.tf

data "aws_region" "current" {}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}
