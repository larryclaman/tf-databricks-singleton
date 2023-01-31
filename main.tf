terraform {
  required_providers {
    azurerm = "~> 2.33"
    random  = "~> 2.2"
    databricks = {
      source = "databricks/databricks"
    }
  }

  backend "azurerm" {
  }

}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Use Azure CLI authentication.
provider "databricks" {
  host = local.databricks_host
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
