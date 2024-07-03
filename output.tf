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