
locals {
  prefix = "cursUnitBv"
}
provider "azurerm" {
  features {}
  client_id       = "4d8cfdcd-660e-4a8c-9499-dfb21b530ae5"
  tenant_id       = "b951053f-91a3-4b70-a0c1-8670b3d6b3b2"
  subscription_id = "f815bd69-e621-40c6-a734-9713e49ee78c"
}


resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${lower(local.prefix)}lucian"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document = "index.html"
  }
}

# resource "azurerm_storage_container" "storage_container" {
#   name                  = "$web"
#   storage_account_name  = azurerm_storage_account.storage_account.name
#   container_access_type = "blob"
# }

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/index.html"
  content_type           = "text/html"
}

output "website_url" {
  value = azurerm_storage_account.storage_account.static_website
}