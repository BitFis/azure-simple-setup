// configure the example app to deploy as service
variable "app_service_plan" {
  type = string
  description = "App service plan to use for the python app"
  default = "F1"
}

resource "random_string" "azurerm_linux_web_app_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_service_plan" "example" {
  name                = "${var.prefix}-core-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan
}

resource "azurerm_linux_web_app" "example" {
  name                = "${var.prefix}-${random_string.azurerm_linux_web_app_name.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  https_only          = true
  enabled             = true

  app_settings = {
    WEBSITES_PORT = 5000
  }

  site_config {
    always_on = false

    application_stack {
      docker_image_name      = "ghcr.io/bitfis/azure-simple-setup/python-app:latest"
    }
  }
}

output "app_hostname" {
  value       = azurerm_linux_web_app.example.default_hostname
  description = "Linux Web App default hostname"
}