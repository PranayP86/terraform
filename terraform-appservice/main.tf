# Create an App Service Plan with Linux
resource "azurerm_app_service_plan" "AppServerPlan" {
  name                = "${var.app_service_name}plan"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    tier = var.tier_name
    size = var.size_name
  }
}
# Create an Azure Web App for Containers in that App Service Plan
resource "azurerm_app_service" "AppService" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.AppServerPlan.id
}