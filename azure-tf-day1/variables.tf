variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Base resource group name"
  type = string
}
