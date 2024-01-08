############################### Vnet Azure ###########################################

resource "azurerm_virtual_network" "wpvnet" {
  name                = "tonyvnetwordpress"
  location            = data.azurerm_resource_group.RSG.location
  resource_group_name = data.azurerm_resource_group.RSG.name
  address_space       = ["172.18.0.0/16"]
}

# Subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = data.azurerm_resource_group.RSG.name
  virtual_network_name = azurerm_virtual_network.wpvnet.name
  address_prefixes     = ["172.18.1.0/24"]
}


###Subnet for MySQL server
resource "azurerm_subnet" "mysql_subnet" {
  name                 = "mysql-subnet"
  resource_group_name  = data.azurerm_resource_group.RSG.name
  virtual_network_name = azurerm_virtual_network.wpvnet.name
  address_prefixes     = ["172.18.2.0/24"]
  service_endpoints = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

###### Subnet for VM ###################

resource "azurerm_subnet" "vmsubnet" {
  name                 = "vmsubnet"
  resource_group_name  = data.azurerm_resource_group.RSG.name
  virtual_network_name = azurerm_virtual_network.wpvnet.name
  address_prefixes     = ["172.18.3.0/24"]
}