resource "azurerm_kubernetes_cluster" "myakscluster" {
  name =  "myakscluster"
  location = azurerm_resource_group.rgone.location
  resource_group_name = azurerm_resource_group.rgone.name

  default_node_pool {
    name = "myaksclusternodepool"
    vm_size = "Standard_D2_v2"
    node_count = 2
  }

  identity {
    type = "SystemAssigned"
  }

}