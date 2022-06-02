provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

variable "nsg_rules" {
  type = map(any)
  default = {
    101 = 80
    102 = 443
    103 = 3389
    104 = 22
  }
}

resource "azurerm_resource_group" "rg-vm" {
  name     = "rg-vm"
  location = var.location
}

resource "azurerm_virtual_network" "vm-vnet" {
  name                = "vm-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-vm.name
  address_space       = ["10.0.0.0/16", "192.168.0.0/16"]
}

resource "azurerm_subnet" "vm-subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.rg-vm.name
  virtual_network_name = azurerm_virtual_network.vm-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vm-subnet-ip" {
  name                    = "vm-subnet-ip"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg-vm.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label       = "vmeschechola"
}

resource "azurerm_network_interface" "vm-nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-vm.name

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-subnet-ip.id
  }
}

resource "azurerm_network_security_group" "vm-nsg" {
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-vm.name
}

resource "azurerm_network_security_rule" "vm-nsg-rule" {
  for_each                    = var.nsg_rules
  resource_group_name         = azurerm_resource_group.rg-vm.name
  name                        = "rule_${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  source_port_range           = "*"
  protocol                    = "Tcp"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.vm-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-link" {
  subnet_id                 = azurerm_subnet.vm-subnet.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id

}

resource "azurerm_virtual_machine" "vm-linux" {
  name                  = "vm-linux"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg-vm.name
  network_interface_ids = [azurerm_network_interface.vm-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "vm-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "eschecholapc"
    admin_username = "eschechola"
    admin_password = "3scH3chOl4@123"
  }
}