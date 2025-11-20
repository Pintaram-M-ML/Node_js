resource "azurerm_kubernetes_cluster" "example" {
  name                = "aks-cluster1"
  location            = azurerm_resource_group.jenkins_rg.location
  resource_group_name = azurerm_resource_group.jenkins_rg.name
  dns_prefix          = "jenkinsdns"

  default_node_pool {
    name                       = "default"
    vm_size                    = var.node_size
    auto_scaling_enabled       = true
    min_count                  = 1
    max_count                  = 2
    vnet_subnet_id             = azurerm_subnet.aks_pod_subnet.id
    temporary_name_for_rotation = "temp1"
  }

  identity {
    type = "SystemAssigned"
  }

 network_profile {
  network_plugin = "azure"
  service_cidr   = "10.3.0.0/24"
  dns_service_ip = "10.3.0.11"
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
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}
