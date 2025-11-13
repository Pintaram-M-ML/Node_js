terraform {
  backend "azurerm" {
    resource_group_name = "jenkins-rg"
    storage_account_name = "jenkingstorage"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}