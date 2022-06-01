data "http" "ip_address" {
  url = "https://api.ipify.org"
  request_headers = {
    "Accept" = "text/plain"
  }
}

resource "azurerm_mssql_firewall_rule" "sql-firewall-rule-myip" {
  name             = "sql-firewall-rule-myip"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = data.http.ip_address.body
  end_ip_address   = data.http.ip_address.body
}

resource "azurerm_mssql_firewall_rule" "sql-firewall-rule-all" {
  name             = "sql-firewall-rule-all"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_mssql_firewall_rule" "sql-firewall-rule-azresources" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}