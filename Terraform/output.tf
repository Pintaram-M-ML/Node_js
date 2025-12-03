output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}
output "aks_node_public_ips" {
  value = azurerm_kubernetes_cluster.example.default_node_pool[0].node_public_ip_prefix_id
}
