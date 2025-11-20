terraform {
  backend "azurerm" {
    resource_group_name = "jenkins-rg1"
    storage_account_name = "jenkingstorage1"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}
