
resource "azurerm_storage_account" "wasim_stg" {
  name                     = "wasimstg"
  resource_group_name      = azurerm_resource_group.rgone.name
  location                 = azurerm_resource_group.rgone.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}

resource "azurerm_storage_container" "wasim_cont" {
  name                  = "vhds"
  storage_account_id    = azurerm_storage_account.wasim_stg.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "vm_output_blob" {
  name                   = "vm_output.csv"
  storage_account_name   = azurerm_storage_account.wasim_stg.name
  storage_container_name = azurerm_storage_container.wasim_cont.name
  type                   = "Block"
  source                 = "${path.cwd}/vm_output1.csv"

  depends_on = [local_file.vm_output_csv]

}
