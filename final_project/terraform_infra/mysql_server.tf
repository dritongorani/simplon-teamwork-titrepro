
##### Mysql flexible server ############################

resource "azurerm_mysql_flexible_server" "wpserver" {
  name                   = var.mysqlservername
  resource_group_name    = data.azurerm_resource_group.RSG.name
  location               = data.azurerm_resource_group.RSG.location
  administrator_login    = var.databaseuseradmin
  administrator_password = var.databasepass
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.mysql_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.privatedns.id
  sku_name               = "B_Standard_B1s"
  
  geo_redundant_backup_enabled = true
  depends_on = [azurerm_private_dns_zone_virtual_network_link.tonywp]
}
#### Database ####
resource "azurerm_mysql_flexible_database" "wpdatabaseprod" {
  name                = var.wordpressdbprod
  resource_group_name = data.azurerm_resource_group.RSG.name
  server_name         = azurerm_mysql_flexible_server.wpserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_database" "wpdatabasedev" {
  name                = var.wordpressdbdev
  resource_group_name = data.azurerm_resource_group.RSG.name
  server_name         = azurerm_mysql_flexible_server.wpserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}


########################################################################################


resource "azurerm_private_dns_zone" "privatedns" {
  name                = "tony.mysql.database.azure.com"
  resource_group_name = data.azurerm_resource_group.RSG.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "tonywp" {
  name                  = "tonywpVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.privatedns.name
  virtual_network_id    = azurerm_virtual_network.wpvnet.id
  resource_group_name   = data.azurerm_resource_group.RSG.name
}
