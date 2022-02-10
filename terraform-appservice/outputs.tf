output "app_service_plan_id" {
  value = azurerm_app_service_plan.AppServerPlan.id
}
output "name" {
  value = azurerm_app_service.AppService.name
}
output "webapp_endpoint" {
  value = azurerm_app_service.AppService.default_site_hostname
}
