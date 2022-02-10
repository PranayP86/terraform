terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = var.azure-subscription-id
  client_id       = var.CLIENTID
  client_secret   = var.CLIENTSECRET
  tenant_id       = var.azure-tenant-id
}

# Connect the resource group
# CHANGED TO MUST IMPORT FROM USER
# terraform import azurerm_resource_group.cloudapp-rg
resource "azurerm_resource_group" "CL-AZU-Capabilities" {
  name = "CL-AZU-Capabilities"
  location = "East US"
    lifecycle {
        prevent_destroy = true
    }
}

resource "azurerm_resource_group" "cloudapp-rg" {
  name     = var.resource-group-name
  location = var.az-location
}

#Create vNet
resource "azurerm_virtual_network" "cloudappvnet" {
  name                = "${var.deployment-name}-vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cloudapp-rg.location
  resource_group_name = azurerm_resource_group.cloudapp-rg.name
}

resource "azurerm_network_security_group" "cloudappNSG" {
  name                = "${var.deployment-name}-NSG"
  location            = azurerm_resource_group.cloudapp-rg.location
  resource_group_name = azurerm_resource_group.cloudapp-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Mongo"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "27017"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "development"
  }
}

#Create Subnet
resource "azurerm_subnet" "cloudappsubnet" {
  name                 = "${var.deployment-name}-subnet"
  resource_group_name  = azurerm_resource_group.cloudapp-rg.name
  virtual_network_name = azurerm_virtual_network.cloudappvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "mongoVMpublicIP" {
  name                = "${var.deployment-name}-publicIP"
  location            = azurerm_resource_group.cloudapp-rg.location
  resource_group_name = azurerm_resource_group.cloudapp-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "development"
  }
}

#Create Network Interface
resource "azurerm_network_interface" "cloudappNI" {
  name                = "${var.deployment-name}-NI"
  location            = azurerm_resource_group.cloudapp-rg.location
  resource_group_name = azurerm_resource_group.cloudapp-rg.name

  ip_configuration {
    name                          = "config1"
    subnet_id                     = azurerm_subnet.cloudappsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mongoVMpublicIP.id
  }
}

#Connect Security Group to Network Interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.cloudappNI.id
  network_security_group_id = azurerm_network_security_group.cloudappNSG.id
}

#Create Storage Account
# resource "azurerm_storage_account" "cloudappstorageacct" {
#   name                     = "${var.deployment-name}storageacct"
#   resource_group_name      = azurerm_resource_group.cloudapp-rg.name
#   location                 = azurerm_resource_group.cloudapp-rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#
#   tags = {
#     environment = "development"
#   }
# }

#Create Storage Container
# resource "azurerm_storage_container" "cloudappstoragecont" {
#   name                  = "${var.deployment-name}-storagecontainer"
#   storage_account_name  = azurerm_storage_account.cloudappstorageacct.name
#   container_access_type = "private"
# }

resource "random_id" "randomdiskname" {
  byte_length = 8
}

#Create the Virtual Machine
resource "azurerm_virtual_machine" "cloudappVM" {
  name                  = "${var.deployment-name}-VM"
  location              = azurerm_resource_group.cloudapp-rg.location
  resource_group_name   = azurerm_resource_group.cloudapp-rg.name
  network_interface_ids = [azurerm_network_interface.cloudappNI.id]
  vm_size               = "Standard_A1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = local.osdiskname
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = var.machine-name
    admin_username = var.admin-name
    admin_password = var.admin-password
  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path     = "/home/${var.admin-name}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  connection {
    host        = ""
    user        = ""
    type        = "ssh"
    private_key = ""
    timeout     = "1m"
    agent       = true
  }

  tags = {
    environment = "development"
  }
}

#Script to install MongoDB after VM provisioning (Base64 Encoded

# sudo apt-get install gnupg
# wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
# echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
# sudo apt-get update
# sudo apt-get install -y mongodb-org
# sudo sed -i 's/127.0.0.1/127.0.0.1,10.0.2.4/g' /etc/mongod.conf
# sudo systemctl restart mongod

resource "azurerm_virtual_machine_extension" "cloudappVMextension" {
  name                 = "${var.deployment-name}-VMExtension"
  virtual_machine_id   = azurerm_virtual_machine.cloudappVM.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "c3VkbyBhcHQtZ2V0IGluc3RhbGwgZ251cGcKd2dldCAtcU8gLSBodHRwczovL3d3dy5tb25nb2RiLm9yZy9zdGF0aWMvcGdwL3NlcnZlci00LjQuYXNjIHwgc3VkbyBhcHQta2V5IGFkZCAtCmVjaG8gImRlYiBbIGFyY2g9YW1kNjQsYXJtNjQgXSBodHRwczovL3JlcG8ubW9uZ29kYi5vcmcvYXB0L3VidW50dSBiaW9uaWMvbW9uZ29kYi1vcmcvNC40IG11bHRpdmVyc2UiIHwgc3VkbyB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvbW9uZ29kYi1vcmctNC40Lmxpc3QKc3VkbyBhcHQtZ2V0IHVwZGF0ZQpzdWRvIGFwdC1nZXQgaW5zdGFsbCAteSBtb25nb2RiLW9yZwpzdWRvIHNlZCAtaSAncy8xMjcuMC4wLjEvMTI3LjAuMC4xLDEwLjAuMi40L2cnIC9ldGMvbW9uZ29kLmNvbmYKc3VkbyBzeXN0ZW1jdGwgcmVzdGFydCBtb25nb2QK"
    }
SETTINGS


  tags = {
    environment = "development"
  }
}
