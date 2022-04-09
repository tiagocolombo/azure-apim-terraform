terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }

  # Terraform doesn't support variables in the backend config
  # Pass the backend config file when initiating terraform at runtime
  # terraform init -backend-config=backend.${env}
  backend "azurerm" {}

  required_version = ">= 1.1.0"
}