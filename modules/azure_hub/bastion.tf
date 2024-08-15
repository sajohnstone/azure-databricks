resource "random_password" "password" {
  length  = 16
  special = true
}

resource "azurerm_public_ip" "this" {
  count = var.boolean_create_bastion ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "this" {
  count = var.boolean_create_bastion ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ip-001"
    private_ip_address            = "10.0.7.10"
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.this["hub-${var.name}-hub-public"].id
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  count = var.boolean_create_bastion ? 1 : 0

  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.this[0].id]
  size                  = "Standard_B2s"
  computer_name         = "vm-prod"

  admin_username = "AzureAdmin"
  admin_password = random_password.password.result

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
