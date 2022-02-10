variable "admin-login" {
  type        = string
  description = "Login to authenticate to MySQL Server"
}
variable "admin-password" {
  type        = string
  description = "Password to authenticate to MySQL Server"
}
variable "mysql-version" {
  type        = string
  description = "MySQL Server version to deploy"
  default     = "8.0"
}
variable "mysql-sku-name" {
  type        = string
  description = "MySQL SKU Tier Name"
  # default     = "B_Gen5_1"
}
variable "mysql-storage" {
  type        = string
  description = "MySQL Storage in MB"
  # default     = "5120"
}
variable "azure-subscription-id" {
  type        = string
  description = "Subscription ID for Azure Account"
}
variable "CLIENTID" {
  type        = string
  description = "Client ID kept as env variable"
}
variable "CLIENTSECRET" {
  type        = string
  description = "Client secret kept as env variable"
}
variable "azure-tenant-id" {
  type        = string
  description = "Subscription ID for Azure Account"
}
variable "deployment-name" {
  type        = string
  description = "Name of deployment used for naming of resources"
}
variable "resource-group-name" {
  type        = string
  description = "Name of the resource group created"
  # default     = "CL-AZU-Capabilities"
}
variable "az-location" {
  type        = string
  description = "Location of instance"
  # default     = "East US"
}
variable "firewall-start-ip" {
  type        = string
  description = "Beginning of firewall IP range"
  default     = "0.0.0.0"
}
variable "firewall-end-ip" {
  type        = string
  description = "End of firewall IP range"
  default     = "0.0.0.0"
}
