
### Variables ###

variable "cluster_name" {
  default = "dritonclusterprod"
}

variable "dns_prefix" {
  default = "k8stest"
}



variable "mysqlservername" {
  default = "tonywpserver"
}

variable "databaseuseradmin" {
  
}

variable "databasepass" {
  
}

variable "wordpressdbprod" {
  default = "wpdatabaseprod"
}

variable "wordpressdbdev" {
  default = "wpdatabasedev"
}


##### NSG variables #####

variable "aksnsg" {
  default = "aksnsg"
}

variable "mysqlnsg" {
  default = "mysqlnsg"
}

variable "vmnsg" {
  default = "vmnsg"
}


