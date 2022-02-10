terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = var.azure-subscription-id
  client_id       = var.CLIENTID
  client_secret   = var.CLIENTSECRET
  tenant_id       = var.azure-tenant-id
}

# Connect the resource group
# terraform import 
resource "azurerm_resource_group" "CL-AZU-Capabilities" {
  name     = var.resource-group-name
  location = var.az-location
}

resource "azurerm_mysql_server" "cloudappsqlserver" {
  name                = "${var.deployment-name}sqlserver"
  location            = azurerm_resource_group.CL-AZU-Capabilities.location
  resource_group_name = azurerm_resource_group.CL-AZU-Capabilities.name

  administrator_login          = var.admin-login
  administrator_login_password = var.admin-password

  sku_name = var.mysql-sku-name
  version  = var.mysql-version

  storage_mb = var.mysql-storage

  ssl_enforcement_enabled = true
}

resource "azurerm_mysql_database" "cloudappmysqldb" {
  name                = "${var.deployment-name}sqldb"
  resource_group_name = azurerm_resource_group.CL-AZU-Capabilities.name
  server_name         = azurerm_mysql_server.cloudappsqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Opens SQL Server Port 1433 for connection
resource "azurerm_network_security_group" "cloudappNSG" {
  name                = "${var.deployment-name}-NSG"
  location            = azurerm_resource_group.CL-AZU-Capabilities.location
  resource_group_name = azurerm_resource_group.CL-AZU-Capabilities.name

  security_rule {
    name                       = "SQLPort"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    environment = "development"
  }
}

# Creates firewall rile
resource "azurerm_mysql_firewall_rule" "cloudappmysqlfw" {
  name                = "${var.deployment-name}firewall"
  resource_group_name = azurerm_resource_group.CL-AZU-Capabilities.name
  server_name         = azurerm_mysql_server.cloudappsqlserver.name
  # IP Range (Change in terraform.tfvars)
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
