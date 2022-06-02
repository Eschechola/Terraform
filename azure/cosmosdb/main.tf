provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-cosmosdb" {
  name     = "rg-cosmosdb"
  location = var.location
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "eschechola-cosmosdb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-cosmosdb.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.rg-cosmosdb.location
    failover_priority = 1
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}