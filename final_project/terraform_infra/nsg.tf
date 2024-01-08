###################### MYSQL NSG ##############################

resource "azurerm_network_security_group" "mysqlnsg" {
  name                = var.mysqlnsg
  location            = data.azurerm_resource_group.RSG.location
  resource_group_name = data.azurerm_resource_group.RSG.name
  
     security_rule {
    name                       = "allowaksaccessaks"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "172.18.1.0/24"
    destination_address_prefix = "*"
  }

       security_rule {
    name                       = "allowaksaccessvm"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "172.18.3.0/24"
    destination_address_prefix = "*"
  }
        security_rule {
    name                       = "deny"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "mysqlsubnetasso" {
  subnet_id                 = azurerm_subnet.mysql_subnet.id
  network_security_group_id = azurerm_network_security_group.mysqlnsg.id
  
}

####################################AKS NSG############################################################
resource "azurerm_network_security_group" "aksnsg" {
  name                = var.aksnsg
  location            = data.azurerm_resource_group.RSG.location
  resource_group_name = data.azurerm_resource_group.RSG.name
  

         security_rule {
    name                       = "accessaks"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

     security_rule {
    name                       = "allowmysqlaccess"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "172.18.2.0/24"
    destination_address_prefix = "*"
  }
       security_rule {
    name                       = "deny"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "aks_subnet" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aksnsg.id
  
}
######################################VM NSG##########################################################
resource "azurerm_network_security_group" "vmnsg" {
  name                = var.vmnsg
  location            = data.azurerm_resource_group.RSG.location
  resource_group_name = data.azurerm_resource_group.RSG.name
  
     security_rule {
    name                       = "denyall"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

       security_rule {
    name                       = "accessvm"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "2230"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "vmnsg" {
  subnet_id                 = azurerm_subnet.vmsubnet.id
  network_security_group_id = azurerm_network_security_group.vmnsg.id
  
}
