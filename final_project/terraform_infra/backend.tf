terraform {
  backend "azurerm" {
    resource_group_name  = "PERSO_DRITON"
    storage_account_name = "tonystocreate"
    container_name       = "mytfstatecontainer"
    key                  = "prod.terraform.tfstate"
  }
}


###hello 123456sdd