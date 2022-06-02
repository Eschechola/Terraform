provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-postgres" {
  name     = "rg-postgres"
  location = var.location
}

resource "azurerm_postgresql_server" "postgres-server" {
  name                = "example-psqlserver"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-postgres.name

  administrator_login          = "l0g1n_adm"
  administrator_login_password = "p4sSw0Rd!"

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "postgres-db" {
  name                = "dbtest"
  resource_group_name = azurerm_resource_group.rg-postgres.name
  server_name         = azurerm_postgresql_server.postgres-server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}