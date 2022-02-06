variable "location" {}

variable "tags" {
    type = map
}

variable "prefix" {
    type = string
    default = "tc"
}

variable "resourceFunction" {
    type = string
}

variable "environment" {
    type = string
}

variable "storageAccountSku" {
    default = {
        tier = "Standard"
        type = "GRS"
    }
}

variable "apimSku" {
    type = string
}

variable "apimSkuCapacity" {
    type = number
}

variable "apimPublisherName" {
    type = string
}

variable "apimPublisherEmail" {
    type = string
}

variable "product" {
    type = map
}

variable "subscription" {
    type = map
}