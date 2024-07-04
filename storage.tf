data "azurerm_client_config" "current" {}

# Generate random value for the storage account name
resource "random_string" "storage_account_name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = "${random_string.storage_account_name.result}"

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}

// custom storage container .. WIP
resource "azurerm_storage_container" "app" {
  name                  = "app"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

// test overwrite use storage
resource "azurerm_storage_blob" "public" {
  name = "index.html"
  storage_account_name = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  access_tier = "Cool"
  type = "Block"
  content_type = "text/html"
  source = "static/index.html"
}

resource "azurerm_storage_blob" "index" {
  name = "index.html"
  storage_account_name = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.app.name
  access_tier = "Cool"
  type = "Block"
  content_type = "text/html"
  source = "static/index.html"
}

resource "azurerm_storage_blob" "data" {
  name = "test.json"
  storage_account_name = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.app.name
  access_tier = "Cool"
  type = "Block"
  content_type = "text/json"
  source = "static/test.json"
}

data "azurerm_storage_account_blob_container_sas" "example" {
  connection_string = azurerm_storage_account.storage_account.primary_connection_string 
  container_name    = azurerm_storage_container.app.name
  https_only        = true

  start  = "${formatdate("YYYY-MM-DD", timestamp())}"
  expiry = "${formatdate("YYYY-MM-DD", timeadd(timestamp(),"8640h"))}"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }

  cache_control       = "max-age=5"
}
