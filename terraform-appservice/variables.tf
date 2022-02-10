variable "resource_group_name" {
  type        = string
  description = "Existing resource group name"
}
variable "location" {
  type        = string
  description = "Azure location"
}
variable "app_service_name" {
  description = "app service name"
  type        = string
}
variable "tier_name" {
  type    = string
  default = "Standard"
}
variable "size_name" {
  type    = string
  default = "S1"
}
