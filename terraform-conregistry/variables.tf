variable "container_registry_name" {
  type        = string
  description = "Name of container registry"
}
variable "resource_group_name" {
  type        = string
  description = "Existing resource group name"
}
variable "location" {
  type        = string
  description = "Azure location"
}
variable "container_registry_sku" {
  type        = string
  description = "Service plan"
  default     = "Standard"
}
variable "admin_enabled" {
  type        = bool
  description = "Enable admin access"
  default     = true
}
