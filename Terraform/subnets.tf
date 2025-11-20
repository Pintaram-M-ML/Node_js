resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet1"
  resource_group_name  = azurerm_resource_group.jenkins_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
