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

variable "apim" {
    type = map
}