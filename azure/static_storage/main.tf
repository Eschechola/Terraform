provider "azurerm" {
  features {

  }
}

variable "location" {
  type    = string
  default = "brazilsouth"
}


resource "azurerm_resource_group" "rg-static-website" {
  name     = "rg-static-website"
  location = var.location
}

resource "azurerm_storage_account" "staticwebsite" {
  name                      = "eschecholasttwebsite"
  resource_group_name       = azurerm_resource_group.rg-static-website.name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
  }
}