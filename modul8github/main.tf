# Locals
locals {
  workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
  rg_name          = "${var.rg_name}-${local.workspaces_suffix}"
  sa_name          = "${lower(replace(var.sa_name, "_", ""))}${local.workspaces_suffix}"  
  
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
  account_replication_type  = "LRS"
}

