provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-appservice-slots" {
  name     = "rg-appservice-slots"
  location = var.location
}

resource "azurerm_service_plan" "planeschecholaslots" {
  name                = "planeschecholaslots"
  resource_group_name = azurerm_resource_group.rg-appservice-slots.name
  location            = var.location
  sku_name            = "P1v2"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "appeschecholaslots" {
  name                = "appeschecholaslots"
  resource_group_name = azurerm_resource_group.rg-appservice-slots.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.planeschecholaslots.id
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

resource "azurerm_linux_web_app_slot" "appeschecholaslot" {
  name           = "eschechola-slot"
  app_service_id = azurerm_linux_web_app.appeschecholaslots.id

  site_config {}
}