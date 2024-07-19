resource "random_password" "service_principal" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "service_principal" {
  name         = "service-principal-password"
  value        = random_password.service_principal.result
  key_vault_id = azurerm_key_vault.this.id
}

resource "azuread_application" "this" {
  display_name = format("app-%s-%s-%s",
  local.naming.location[var.location], var.environment, var.project)
}

resource "azuread_service_principal" "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
  value                = azurerm_key_vault_secret.service_principal.value
}

resource "azurerm_role_assignment" "this" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.this.object_id
}
