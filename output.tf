output "cdn_endpoint_fqdn" {
  value = azurerm_cdn_endpoint.endpoint.fqdn
}

output "primary_web_host" {
  value = azurerm_storage_account.storage_account.primary_web_host
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "container_access" {
  value = azurerm_storage_blob.index.url
}

output "sas_url_query_string" {
  value = "${azurerm_storage_blob.index.url}${data.azurerm_storage_account_blob_container_sas.example.sas}"
  sensitive = true
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_container_name" {
  value = azurerm_storage_container.app.name
}

output "storage_account_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}

output "auth_url" {
  value = azurerm_function_app_function.auth.invocation_url
}