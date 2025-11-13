terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }

  required_version = ">=1.9.0"
}

provider "azurerm" {
    features {}
    subscription_id = "609abdba-d9b6-41fa-a6e7-c63c49f82b9f"
}