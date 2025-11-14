resource "azurerm_kubernetes_cluster" "example" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.jenkins_rg.location
  resource_group_name = azurerm_resource_group.jenkins_rg.name
  dns_prefix          = "jenkinsdns"

 default_node_pool {
  name                = "default"
  vm_size             = "Standard_DS2_v2"

  auto_scaling_enabled = true
  min_count            = 1
  max_count            = 3
}



  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}