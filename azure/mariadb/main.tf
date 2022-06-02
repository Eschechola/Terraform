provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-mariadb" {
  name     = "rg-mariadb"
  location = var.location
}

resource "azurerm_mariadb_server" "mariadb-server" {
  name                = "mysqlserver"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-mariadb.name

  administrator_login          = "l0g1n_adm"
  administrator_login_password = "p4sSw0Rd!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true
  ssl_enforcement_enabled       = true
}

resource "azurerm_mariadb_database" "mariadb-database" {
  name                = "dbtest"
  resource_group_name = azurerm_resource_group.rg-mariadb.name
  server_name         = azurerm_mariadb_server.mariadb-server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}