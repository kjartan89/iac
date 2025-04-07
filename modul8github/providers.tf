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
    key = "rgmodul8.terraform.tfstate"
  }
}

provider "azurerm" {
    features {}
  
}