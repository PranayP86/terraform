variable "subscription_id" {
  type        = string
  description = "Azure Subscription id"
}
variable "tenant_id" {
  type        = string
  description = "Azure tenant_id"
}
variable "client_id" {
  type        = string
  description = "Azure Client id"
}
variable "client_secret" {
  type        = string
  description = "Azure Client secret"
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
variable "tier_name" {
  type    = string
  default = "Standard"
}
variable "size_name" {
  type    = string
  default = "S1"
}
variable "admin_enabled" {
  type        = bool
  description = "Enable admin access"
  default     = true
}
variable "deployment_name" {
  type = string
}
variable "mongodb_username" {
  type        = string
  description = "MongoDB Server Admin Username"
}
variable "mongodb_password" {
  type        = string
  description = "MongoDB Server Admin Password"
}
variable "mysql_username" {
  type        = string
  description = "MySQL Server Admin Username"
}
variable "mysql_password" {
  type        = string
  description = "MySQL Server Admin Password"
}