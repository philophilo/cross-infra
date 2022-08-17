variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_account" {
  type = string
}

variable "vpc" {
  type = string
}

variable "subnet" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "node_pool" {
  type = string
}

variable "autoscaling_cpu" {
  type = number
}

variable "autoscaling_memory" {
  type = number
}

variable "autoscaling_min_node_count" {
  type = number
}

variable "autoscaling_max_node_count" {
  type = number
}

variable "autoscaling_machine_type" {
  type = string
}
