# Define a private DNS zone for the dbfs_dfs resource
resource "azurerm_private_dns_zone" "dbfs_dfs" {
  count = var.boolean_adfs_privatelink ? 1 : 0

  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Define a private endpoint for the dbfs_dfs resource
resource "azurerm_private_endpoint" "dbfs_dfs" {
  count = var.boolean_adfs_privatelink ? 1 : 0

  name                = "dbfspe-dfs"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink.id

  # Define the private service connection for the dbfs_dfs resource
  private_service_connection {
    name                           = "ple-${var.name}-dbfs-dfs"
    private_connection_resource_id = data.azurerm_storage_account.this[0].id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }

  # Associate the private DNS zone with the private endpoint
  private_dns_zone_group {
    name                 = "private-dns-zone-dbfs"
    private_dns_zone_ids = [azurerm_private_dns_zone.dbfs_dfs[0].id]
  }

  tags = var.tags
}

# Define a virtual network link for the dbfs_dfs private DNS zone
resource "azurerm_private_dns_zone_virtual_network_link" "dbfs_dfs" {
  count = var.boolean_adfs_privatelink ? 1 : 0

  name                  = "dbfs-dfs"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dbfs_dfs[0].name
  virtual_network_id    = data.azurerm_virtual_network.spoke_vnet.id

  tags = var.tags
}

# Define a private endpoint for the dbfs_blob resource
resource "azurerm_private_endpoint" "dbfspe_blob" {
  count = var.boolean_adfs_privatelink ? 1 : 0

  name                = "dbfs-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink.id

  # Define the private service connection for the dbfs_blob resource
  private_service_connection {
    name                           = "ple-${var.name}-dbfs-blob"
    private_connection_resource_id = data.azurerm_storage_account.this[0].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  # Associate the private DNS zone with the private endpoint
  private_dns_zone_group {
    name                 = "private-dns-zone-dbfs"
    private_dns_zone_ids = [azurerm_private_dns_zone.dbfs_blob[0].id]
  }

  tags = var.tags
}

# Define a private DNS zone for the dbfs_blob resource
resource "azurerm_private_dns_zone" "dbfs_blob" {
  count = var.boolean_adfs_privatelink ? 1 : 0

  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Define a virtual network link for the dbfs_blob private DNS zone
resource "azurerm_private_dns_zone_virtual_network_link" "dbfs_blob" {
  count = var.boolean_adfs_privatelink ? 1 : 0

  name                  = "dbfs-blob"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dbfs_blob[0].name
  virtual_network_id    = data.azurerm_virtual_network.spoke_vnet.id

  tags = var.tags
}