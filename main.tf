terraform {
  required_providers {
    azurerm = "~> 3.7.0"
    random  = "~> 2.2"
    databricks = {
      source = "databricks/databricks"
    }
  }

  backend "azurerm" {
    use_oidc = true
  }

}

provider "azurerm" {
  features {}
  use_oidc                   = true
  skip_provider_registration = true
}

# Use Azure CLI authentication.
provider "databricks" {
  host                        = azurerm_databricks_workspace.this.workspace_url
  // azure_workspace_resource_id = azurerm_databricks_workspace.this.id
 depends_on = [
    azurerm_databricks_workspace.this.id
 ]
}


variable "region" {
  type    = string
  default = "WestUS3"
}

variable "rg" {
  type    = string
  default = "databricksdemo"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  prefix = "databricksdemo${random_string.naming.result}"
  tags = {
    Environment = "Demo"
    Owner       = lookup(data.external.me.result, "name")
  }

  databricks_host = "https://${azurerm_databricks_workspace.this.workspace_url}/"

}
