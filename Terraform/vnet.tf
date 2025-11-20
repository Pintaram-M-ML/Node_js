//create a virtual network Vnet in Azure
resource "azurerm_virtual_network" "vnet" {
    name = "myVnet"
    resource_group_name = azurerm_resource_group.jenkins_rg.name
    location = azurerm_resource_group.jenkins_rg.location
    address_space = ["10.0.0.0/16"]
}
