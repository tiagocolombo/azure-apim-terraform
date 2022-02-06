terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.95"
    }
  }

  required_version = ">= 1.1.0"
}