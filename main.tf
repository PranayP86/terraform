# azure provider
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  # backend "azurerm" {}
}

# container registry module usage
module "container-registry-module" {
  source                  = "./modules/terraform-azurerm-conregistry"
  container_registry_name = "${var.deployment_name}conreg"
  resource_group_name     = var.resource_group_name
  location                = var.location
  container_registry_sku  = var.container_registry_sku
  admin_enabled           = var.admin_enabled
}

# Create an App Service module usage
module "app-service-module" {
  source              = "./modules/terraform-azurerm-appservice"
  app_service_name    = "${var.deployment_name}appservice"
  location            = var.location
  resource_group_name = var.resource_group_name
  tier_name           = var.tier_name
  size_name           = var.size_name
}

# mongodb module
module "mongodb-module" {
  source              = "./modules/terraform-azurerm-mongodb"
  resource-group-name = var.resource_group_name
  az-location         = var.location
  deployment-name     = var.deployment_name
  admin-name          = var.mongodb_username
  admin-password      = var.mongodb_password
}

# mysql module
module "mysql-module" {
  source              = "./modules/terraform-azurerm-mysql"
  resource-group-name = var.resource_group_name
  az-location         = var.location
  admin-login         = var.mysql_username
  admin-password      = var.mysql_password
  deployment-name     = var.deployment_name
}