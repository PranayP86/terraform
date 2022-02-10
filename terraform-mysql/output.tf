output "cloudappsqlserver" {
  value     = azurerm_mysql_server.cloudappsqlserver
  sensitive = true
}
