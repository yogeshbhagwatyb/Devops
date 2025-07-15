# AWS vs Azure

ami = source_image_reference

aws 
    resource "aws_instance" "example" {
    ami           = "ami-0abcdef1234567890"
    instance_type = "t2.micro"
    }


azure 
    resource "azurerm_linux_virtual_machine" "centos_vm" {
    count                 = 1
    name                  = "centos-vm-${random_string.unique_id.result}"
    location              = data.azurerm_resource_group.my_rg.location
    resource_group_name   = data.azurerm_resource_group.my_rg.name
    network_interface_ids = [azurerm_network_interface.centos_nic[0].id]
    size                  = var.instance_type
    admin_username        = var.admin_username

    depends_on = [azurerm_network_interface.centos_nic]

    os_disk {
        name                 = "osdisk-${random_string.unique_id.result}"
        caching              = "ReadWrite"
        storage_account_type = var.os_disk_type
        disk_size_gb         = var.os_disk_size
    }

    admin_ssh_key {
        username   = var.admin_username
        public_key = var.private_key != null ? var.private_key : tls_private_key.centos_ssh_key[0].public_key_openssh
    }
    #tls_private_key.centos_ssh_key.public_key_openssh

    source_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "8_4"
        version   = "latest"
    }

    tags = {
        environment = "dev"
    }

    }