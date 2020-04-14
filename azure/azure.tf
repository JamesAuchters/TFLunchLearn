variable "azureprofile" {
    type = "map"
}

provider "azurerm" {
    version = "=1.43.0"
    subscription_id             = var.azureprofile["subscriptionid"]
    client_id                   = var.azureprofile["client_id"]
    client_certificate_path     = var.azureprofile["certpath"]
    client_certificate_password = var.azureprofile["certpass"]
    tenant_id                   = var.azureprofile["tenantid"]
}

variable "VNetName" {
    type = "string"
    #Should really use a default and not be a gronk
}

variable "networkrange" {
    type = "list"
    default = ["10.0.0.0/16"]
}

variable "deployregions" {
    type = "map"
    default = {
        "aws" = "ap-southeast-2"
        "gcp" = "australia-southeast1"
        "azure" = "australiaeast"
    }
}

variable "Sub0CIDR" {
    type = "string"
    default = "10.0.0.0/24"
}

variable "Sub1CIDR" {
    type = "string"
    default = "10.0.1.0/24"
}

variable "Sub2CIDR" {
    type = "string"
    default = "10.0.2.0/24"
}

resource "azurerm_resource_group" "Azure-ResourceGroup" {
    name     = "TERRAFORM-RG01"
    location = var.deployregions["azure"]
}

resource "azurerm_virtual_network" "Azure-VNet" {
    name                = var.VNetName
    resource_group_name = azurerm_resource_group.Azure-ResourceGroup.name
    location            = var.deployregions["azure"]
    address_space       = var.networkrange
    depends_on = [azurerm_resource_group.Azure-ResourceGroup]
}

resource "azurerm_subnet" "Azure-VNetSubnet0" {
    name                 = "SUB00"
    resource_group_name  = azurerm_resource_group.Azure-ResourceGroup.name
    virtual_network_name = var.VNetName
    address_prefix       = var.Sub0CIDR
    depends_on = [azurerm_virtual_network.Azure-VNet]
}

resource "azurerm_subnet" "Azure-VNetSubnet1" {
    name                 = "SUB01"
    resource_group_name  = azurerm_resource_group.Azure-ResourceGroup.name
    virtual_network_name = var.VNetName
    address_prefix       = var.Sub1CIDR
    depends_on = [azurerm_virtual_network.Azure-VNet]
}

resource "azurerm_subnet" "Azure-VNetSubnet2" {
    name                 = "SUB02"
    resource_group_name  = azurerm_resource_group.Azure-ResourceGroup.name
    virtual_network_name = var.VNetName
    address_prefix       = var.Sub2CIDR
    depends_on = [azurerm_virtual_network.Azure-VNet]
}