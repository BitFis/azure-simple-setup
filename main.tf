
// Define the Azure Resource Group that will be used by all resources in our configuration.
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "tf-${var.resource_group_name}"
  location = var.location
}
