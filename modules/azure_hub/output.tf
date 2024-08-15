output "admin_password" {
  value     = random_password.password.result
  sensitive = true
}

output "admin_username" {
  value = "AzureAdmin"
}

output "private_ip_address" {
  value = "110.0.6.4"
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.this[0].id
}

output "log_analytics_workspace_primary_shared_key" {
  value     = azurerm_log_analytics_workspace.this[0].primary_shared_key
  sensitive = true
}