
resource "azurerm_resource_group" "this" {
  #name     = "${local.prefix}-rg"
  name     = var.rg
  location = var.region
  tags     = local.tags
}

resource "azurerm_databricks_workspace" "this" {
  name                = "${local.prefix}-workspace"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "premium"
  // sku = "standard"
  # managed_resource_group_name = "${local.prefix}-workspace-rg"
  tags = local.tags
}

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.this.workspace_url}/"
}