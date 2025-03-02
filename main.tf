

resource "azurerm_virtual_machine" "example" {
  for_each             = { for idx, vm in local.vm_data : vm.name => vm }
  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = azurerm_resource_group.rgone.name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  vm_size              = each.value.vm_size

  storage_os_disk {
    name              = "osdisk-${each.key}"
    caching          = "ReadWrite"
    create_option    = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = each.value.name
    admin_username = "adminuser"
    admin_password = "P@ssw0rd123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}


resource "local_file" "vm_output_csv" {
  filename = "${path.module}/vm_output.csv"
  content  = <<EOT
VM Name,Private IP,Public IP
%{for k, vm in azurerm_virtual_machine.vm}
${vm.name},${azurerm_network_interface.nic[k].private_ip_address},${lookup(azurerm_public_ip.vm_pip, k, "N/A")}
%{endfor}
EOT
}
