variable "appid" {
  
}

variable "password" {
  
}

variable "sshkey" {
  
}

variable "vm_data" {
  type = list(object({
    name     = string
    vm_size  = string
    location = string
  }))
}

locals {
  vm_data = csvdecode(file("vm_list.csv"))
}
