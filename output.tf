output "vm_names" {
  value = [for vm in azurerm_virtual_machine.vm : vm.name]
}

output "vm_private_ips" {
  value = { for k, vm in azurerm_virtual_machine.vm : k => azurerm_network_interface.nic[k].private_ip_address }
}

output "vm_public_ips" {
  value = { for k, vm in azurerm_virtual_machine.vm : k => azurerm_public_ip.vm_pip[k].ip_address if contains(keys(azurerm_public_ip.vm_pip), k) }
}

output "vm_details" {
  value = azurerm_virtual_machine.vm
}


