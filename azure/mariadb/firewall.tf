resource "azurerm_mariadb_firewall_rule" "all-firewall-rule" {
  name                = "all-firewall-rule"
  resource_group_name = azurerm_resource_group.rg-mariadb.name
  server_name         = azurerm_mariadb_server.mariadb-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_mariadb_firewall_rule" "azservices-firewall-rule" {
  name                = "azservices-firewall-rule"
  resource_group_name = azurerm_resource_group.rg-mariadb.name
  server_name         = azurerm_mariadb_server.mariadb-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}