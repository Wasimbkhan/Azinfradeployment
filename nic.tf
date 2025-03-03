
resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  location            = azurerm_resource_group.rgone.location
  resource_group_name = azurerm_resource_group.rgone.name
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.rgone.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  for_each = { for idx, vm in local.vm_data : vm.name => vm }

  name                = "${each.value.name}-nic"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rgone.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = [azurerm_public_ip.myvm_pip[each.key].id]
  }
}

resource "azurerm_public_ip" "myvm_pip" {
  for_each = {for idx, vm in local.vm_data : vm.name => vm } 
  name = "${each.value.name}-pip"
  location = each.value.location
  resource_group_name = azurerm_resource_group.rgone.name
  allocation_method = "Dynamic"
}