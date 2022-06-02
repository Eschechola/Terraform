resource "azurerm_postgresql_firewall_rule" "all-firewall-rule" {
  name                = "all-firewall-rule"
  resource_group_name = azurerm_resource_group.rg-postgres.name
  server_name         = azurerm_postgresql_server.postgres-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_postgresql_firewall_rule" "azservices-firewall-rule" {
  name                = "azservices-firewall-rule"
  resource_group_name = azurerm_resource_group.rg-postgres.name
  server_name         = azurerm_postgresql_server.postgres-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}