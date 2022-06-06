provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-acr" {
  name     = "rg-acr"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "eschecholaacr"
  resource_group_name = azurerm_resource_group.rg-acr.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}