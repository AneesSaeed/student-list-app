output "container_registry_login_server" {
  description = "Adresse du registre ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "web_app_url" {
  description = "URL complète de l'application web"
  value       = "https://${azurerm_linux_web_app.vue_app.default_hostname}"
}
