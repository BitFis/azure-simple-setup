// Define the variables that will be used by the Web VM, App VM, and SQL Server resources.
variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
  default     = "rg_example_app"
}

variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
  default     = "West Europe"
}

variable "cdn_sku" {
  type        = string
  description = "CDN SKU names."
  default     = "Standard_Microsoft"
  validation {
    condition     = contains(["Standard_Akamai", "Standard_Microsoft", "Standard_Verizon", "Premium_Verizon"], var.cdn_sku)
    error_message = "The cdn_sku must be one of the following: Standard_Akamai, Standard_Microsoft, Standard_Verizon, Premium_Verizon."
  }
}

variable "origin_url" {
  type        = string
  description = "Url of the origin."
  default     = "www.example.com"
}