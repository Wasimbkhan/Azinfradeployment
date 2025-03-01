locals {
  vm_data = csvdecode(file("vm_list.csv"))
}
