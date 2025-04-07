terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "rg-backend-tfstate-km"
    storage_account_name = "sabekm"
    container_name = "tfstate-km"
    key = "backend.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "random_string" "random_string" {
  length  = 4    
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_backend" {
  name     = var.rg_backend_name
  location = var.rg_backend_location
}


locals {
  sa_name_base = substr(lower(var.sa_backend_name), 0, 20)  
}

resource "azurerm_storage_account" "sa_backend" {
  name                     = var.sa_backend_name
  resource_group_name      = azurerm_resource_group.rg_backend.name
  location                 = azurerm_resource_group.rg_backend.location
  account_tier             = "Standard"
  account_replication_type  = "GRS"
}

resource "azurerm_storage_container" "sc_backend" {
  name                  = var.sc_backend_name
  storage_account_id    = azurerm_storage_account.sa_backend.id  
  container_access_type = "private"
}

resource "azurerm_key_vault" "kv_backend" {
  name                        = "${lower(var.kv_backend_name)}${random_string.random_string.result}"
  location                    = azurerm_resource_group.rg_backend.location
  resource_group_name         = azurerm_resource_group.rg_backend.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Import",
      "Delete",
      "Backup",
      "Restore",
      "Recover",
      "Sign",
      "Verify",
      "Encrypt",
      "Decrypt",
      "WrapKey",
      "UnwrapKey",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "Purge",
      "Release",
      "Rotate"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Backup",
      "Restore",
      "Recover",
      "Purge"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }
}

resource "azurerm_key_vault_secret" "sa_backend_accesskey" {
  name         = var.sa_backend_accesskey_name
  value        = azurerm_storage_account.sa_backend.primary_access_key
  key_vault_id = azurerm_key_vault.kv_backend.id
}