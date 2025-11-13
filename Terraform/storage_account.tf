resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.jenkins_rg.name
  location                 = azurerm_resource_group.jenkins_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}

# Storage Container
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}