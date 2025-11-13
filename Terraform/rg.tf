resource "azurerm_resource_group" "jenkins_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "Jenkins connection"
  }
}