variable "application" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "request_id" {
  type = string
}

variable "deployment_id" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_ssh_public_key" {
  type      = string
  sensitive = true
}
