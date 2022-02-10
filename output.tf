output "registry_admin_username" {
  value = module.container-registry-module.admin_username
}
output "container_registry_login_url" {
  value = module.container-registry-module.login_server
}
output "webapp_endpoint" {
  value = module.app-service-module.webapp_endpoint
}
