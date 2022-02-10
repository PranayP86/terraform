# Container Registry provisioning - Basic
resource "azurerm_container_registry" "container-registry" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.container_registry_sku
  admin_enabled       = var.admin_enabled
}
