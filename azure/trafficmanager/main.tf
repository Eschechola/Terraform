provider "azurerm" {
  features {

  }
}

variable "location-brazil" {
  type    = string
  default = "brazilsouth"
}

variable "location-usa" {
  type    = string
  default = "eastus"
}

resource "azurerm_resource_group" "rg-traffic-manager" {
  name     = "rg-traffic-manager"
  location = var.location-brazil
}

resource "azurerm_traffic_manager_profile" "tmp-eschechola" {
  name                   = "tmp-eschechola"
  resource_group_name    = azurerm_resource_group.rg-traffic-manager.name
  traffic_routing_method = "Geographic"
  dns_config {
    relative_name = "eschecholatrafficmanager"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 5
  }
}

// Brazil
resource "azurerm_service_plan" "planeschechola-br" {
  name                = "planeschecholabr"
  resource_group_name = azurerm_resource_group.rg-traffic-manager.name
  location            = var.location-brazil
  sku_name            = "P1v2"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "appeschechola-br" {
  name                = "appeschecholabr"
  resource_group_name = azurerm_resource_group.rg-traffic-manager.name
  location            = var.location-brazil
  service_plan_id     = azurerm_service_plan.planeschechola-br.id
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "tmeeschechola-br" {
  name               = "tmeeschechola-br"
  profile_id         = azurerm_traffic_manager_profile.tmp-eschechola.id
  target_resource_id = azurerm_linux_web_app.appeschechola-br.id
  weight             = 100
  geo_mappings       = ["BR"]
}


// USA
resource "azurerm_service_plan" "planeschechola-usa" {
  name                = "planeschecholausa"
  resource_group_name = azurerm_resource_group.rg-traffic-manager.name
  location            = var.location-usa
  sku_name            = "P1v2"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "appeschechola-usa" {
  name                = "appeschecholausa"
  resource_group_name = azurerm_resource_group.rg-traffic-manager.name
  location            = var.location-usa
  service_plan_id     = azurerm_service_plan.planeschechola-usa.id
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "tmeeschechola-usa" {
  name               = "tmeeschechola-usa"
  profile_id         = azurerm_traffic_manager_profile.tmp-eschechola.id
  target_resource_id = azurerm_linux_web_app.appeschechola-usa.id
  weight             = 101
  geo_mappings       = ["US"]
}