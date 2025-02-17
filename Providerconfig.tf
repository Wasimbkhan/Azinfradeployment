terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.19.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}

terraform {
   backend "azurerm" {
     #resource_group_name = "rgtfstaebackend"
     #storage_account_name = "mycompanystgone"
     #container_name = "mystgcontainer"
     #key = "terraform.tfstate"
   }
}