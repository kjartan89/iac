# Locals
locals {
  workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
  rg_name          = "${var.rg_name}-${local.workspaces_suffix}"
  sa_name          = "${lower(replace(var.sa_name, "_", ""))}${local.workspaces_suffix}"  
  source_content    = "<h1>heisann ${local.rg_name} in workspace: ${terraform.workspace}</h1>"
}

# RG
resource "azurerm_resource_group" "rg" {  
  name     = local.rg_name
  location = var.rg_location
}

# Random string
resource "random_string" "random_string" {  
  length  = 4
  special = false
  upper   = false
  numeric = true
}

# SA
resource "azurerm_storage_account" "sakm" {  
  name                     = "${lower(local.sa_name)}${random_string.random_string.result}"  
  resource_group_name      = azurerm_resource_group.rg.name  
  location                 = azurerm_resource_group.rg.location  
  account_tier             = "Standard"
  account_replication_type  = "GRS"

  static_website {
    index_document = var.index_document
   
  }
}

# Static Website Configuration
resource "azurerm_storage_container" "web" {
  name                  = "$web"
  storage_account_id    = azurerm_storage_account.sakm.id
  container_access_type = "blob"
}

# Add an index.html file to the storage blob
resource "azurerm_storage_blob" "index_html" { 
  name                   = var.index_document
  storage_account_name   = azurerm_storage_account.sakm.name  
  storage_container_name  = azurerm_storage_container.web.name
  type                   = "Block"  
  content_type           = "text/html"
  source_content         = local.source_content
}

output "primary_web_endpoint" {
    value = azurerm_storage_account.sakm.primary_web_endpoint  
}

# Outputs
output "rg_name" {
    value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
    value = "${lower(local.sa_name)}${random_string.random_string.result}"
}