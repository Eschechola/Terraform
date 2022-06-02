provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-mysql" {
  name     = "rg-mysql"
  location = var.location
}

resource "azurerm_mysql_server" "mysql-server" {
  name                = "mysqlserver"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-mysql.name

  administrator_login          = "l0g1n_adm"
  administrator_login_password = "p4sSw0Rd!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}


resource "azurerm_mysql_database" "mysql-database" {
  name                = "dbtest"
  resource_group_name = azurerm_resource_group.rg-mysql.name
  server_name         = azurerm_mysql_server.mysql-server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}