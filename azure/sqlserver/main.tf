provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-sqlserver" {
  name     = "rg-sqlserver"
  location = var.location
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = "eschechola-sqlserver"
  resource_group_name          = azurerm_resource_group.rg-sqlserver.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "eschechola"
  administrator_login_password = "Eschechola@123"
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "mssqldatabase" {
  name         = "db_mssql"
  server_id    = azurerm_mssql_server.sqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = "Basic"
}

