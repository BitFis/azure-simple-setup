// Configure the cdn to provide the content

resource "random_string" "aazurerm_cdn_profile_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_cdn_profile" "profile" {
  name                = "${var.prefix}-profile-${random_string.azurerm_cdn_endpoint_name.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.cdn_sku
}

resource "random_string" "azurerm_cdn_endpoint_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_cdn_endpoint" "endpoint" {
  name                          = "${var.prefix}-${random_string.azurerm_cdn_endpoint_name.result}"
  profile_name                  = azurerm_cdn_profile.profile.name
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  is_http_allowed               = true
  is_https_allowed              = true

  querystring_caching_behaviour = "IgnoreQueryString"
  is_compression_enabled        = true
  content_types_to_compress = [
    "application/eot",
    "application/font",
    "application/font-sfnt",
    "application/javascript",
    "application/json",
    "application/opentype",
    "application/otf",
    "application/pkcs7-mime",
    "application/truetype",
    "application/ttf",
    "application/vnd.ms-fontobject",
    "application/xhtml+xml",
    "application/xml",
    "application/xml+rss",
    "application/x-font-opentype",
    "application/x-font-truetype",
    "application/x-font-ttf",
    "application/x-httpd-cgi",
    "application/x-javascript",
    "application/x-mpegurl",
    "application/x-opentype",
    "application/x-otf",
    "application/x-perl",
    "application/x-ttf",
    "font/eot",
    "font/ttf",
    "font/otf",
    "font/opentype",
    "image/svg+xml",
    "text/css",
    "text/csv",
    "text/html",
    "text/javascript",
    "text/js",
    "text/plain",
    "text/richtext",
    "text/tab-separated-values",
    "text/xml",
    "text/x-script",
    "text/x-component",
    "text/x-java-source",
  ]

  // origin_host_header = azurerm_storage_account.storage_account.primary_blob_host
  origin_host_header = azurerm_storage_account.storage_account.primary_web_host
  origin {
    name      = "origin1"
    host_name = azurerm_storage_account.storage_account.primary_web_host
  }
}