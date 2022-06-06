provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

resource "azurerm_resource_group" "rg-cdnprofile" {
  name     = "rg-cdnprofile"
  location = var.location
}

resource "azurerm_service_plan" "planeschecholacdn" {
  name                = "planeschecholacdn"
  resource_group_name = azurerm_resource_group.rg-cdnprofile.name
  location            = var.location
  sku_name            = "F1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "appeschecholacdn" {
  name                = "appeschecholacdn"
  resource_group_name = azurerm_resource_group.rg-cdnprofile.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.planeschecholacdn.id
  site_config {}
}

resource "azurerm_cdn_profile" "cdn-profile" {
  name                = "cdprofileeschechola"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-cdnprofile.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "cdn-enpoint" {
  name                = "appeschecholacdn-endpoint"
  profile_name        = azurerm_cdn_profile.cdn-profile.name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-cdnprofile.name
  origin_host_header  = azurerm_linux_web_app.appeschecholacdn.default_hostname
  origin {
    name      = azurerm_linux_web_app.appeschecholacdn.name
    host_name = azurerm_linux_web_app.appeschecholacdn.default_hostname

  }
  delivery_rule {
    name  = "EnforceHTTPS"
    order = "1"
    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }
    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }
}