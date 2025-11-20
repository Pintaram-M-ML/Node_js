variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default   = "jenkins-rg1"
  }
  
  variable "storage_account_name" {
    description = "The name of storage Account"
    type        = string
    default     = "jenkingstorage1"
  }
   variable "aks_cluster_name" {
    type = string
    description = "The name of the AKS Cluster"
    default = "my-aks-cluster"
    }

    variable "location" {
        description = "The Azure region to deploy resources"
        type        = string
        default     = "centralindia"
    }
    variable "node_count" {
        description = "The number of nodes in the AKS cluster"
        type        = number
        default     = 2
    }
    variable "node_size" {
        description = "The size of the nodes in the AKS cluster"
        type        = string
        default     = "Standard_A2_v2"
    }
 
