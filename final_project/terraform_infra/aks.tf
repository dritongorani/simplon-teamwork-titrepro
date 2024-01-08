
######## Azurerm kubernetes cluster ###########################################################

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = data.azurerm_resource_group.RSG.location
  name                = var.cluster_name
  resource_group_name = data.azurerm_resource_group.RSG.name
  dns_prefix          = var.dns_prefix
  tags = {
    Environment = "Production"
  }

  identity {
    type = "SystemAssigned"
  }
 default_node_pool {
    name           = "defalut"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id        = azurerm_subnet.aks_subnet.id
    enable_auto_scaling = true
    max_count = 3
    min_count = 1
    
  }

  linux_profile {
    admin_username = "ubuntu"
      ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }


}