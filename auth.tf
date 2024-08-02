// configure the example app to deploy as service
variable "function_service_plan" {
  type = string
  description = "Auth function service plan to use for the auth function (Y1/S1/..)"
  default = "Y1"
}

resource "azurerm_service_plan" "auth" {
  name                = "${var.prefix}-auth-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = var.function_service_plan
}

resource "azurerm_windows_function_app" "auth" {
  name                = "${var.prefix}-auth-function-app"
  location            = azurerm_service_plan.example.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.auth.id

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key

  site_config {
    application_stack {
      dotnet_version = "v8.0"
    }
  }
}

// create the app
resource "azurerm_function_app_function" "auth" {
  name            = "${var.prefix}-auth-function-app-function"
  function_app_id = azurerm_windows_function_app.auth.id
  language        = "CSharp"

  file {
    name    = "run.csx"
    content = file("functions/auth/run.csx")
  }

  file {
    name    = "function.proj"
    content = file("functions/auth/function.proj")
  }

  test_data = jsonencode({
    "token" = "Azure"
  })

  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "anonymous"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
}