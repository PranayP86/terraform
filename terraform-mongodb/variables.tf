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
variable "resource-group-name" {
  type        = string
  description = "Name of the resource group created"
}
variable "az-location" {
  type        = string
  description = "Location of instance"
}
variable "deployment-name" {
  type        = string
  description = "Name of deployment used for naming of resources"
}
variable "machine-name" {
  type        = string
  description = "Name of Virtual Machine computer"
}
variable "admin-name" {
  type        = string
  description = "Name of admin user on Virtual Machine"
}
variable "admin-password" {
  type        = string
  description = "Password of admin user on Virtual Machine"
}
locals {
  osdiskname = "${random_id.randomdiskname.hex}-disk"
}
