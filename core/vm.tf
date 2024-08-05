resource "random_password" "password" {
  length  = 16
  special = true
}

resource "azurerm_public_ip" "this" {
  name                = local.name_prefix
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "this" {
  name                = local.name_prefix
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ip-001"
    private_ip_address            = "10.0.6.10"
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.this["hub-dev-stutest-aue-hub-public"].id
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/scripts/userdata.ps1")
}

resource "azurerm_windows_virtual_machine" "this" {
  name                  = local.name_prefix
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.this.id]
  size                  = "Standard_B2s"
  computer_name         = "vm-prod"

  admin_username = "AzureAdmin"
  admin_password = random_password.password.result

  custom_data = base64encode(data.template_file.userdata.rendered)

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

resource "azurerm_network_security_group" "this" {
  name                = local.name_prefix
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "AllowAnyRDPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.your_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
