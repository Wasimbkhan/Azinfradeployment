

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
  filename = "${path.module}/vm_output2.csv"
  content  = <<EOT
VM Name,Private IP,Public IP
%{for idx, vm in azurerm_virtual_machine.example}
${vm.name},${azurerm_network_interface.nic[idx].private_ip_address},${try(azurerm_public_ip.myvm_pip[idx].ip_address, "N/A")}
%{endfor}
EOT
}



