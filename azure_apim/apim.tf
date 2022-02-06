# Create a new APIM instance
resource "azurerm_api_management" "apim" {
  name                = local.apimName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = var.apimPublisherName
  publisher_email     = var.apimPublisherEmail
  tags                = var.tags

  sku_name            = "${var.apimSku}_${var.apimSkuCapacity}"

  identity {
    type = "SystemAssigned"
  }

  # policy {
  #   xml_link = var.tenantPolicyUrl
  # }
}