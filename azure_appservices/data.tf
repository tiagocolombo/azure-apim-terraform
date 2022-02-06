# Get data reference to logged Azure subcription
data "azurerm_api_management" "apim_service" {
  name                = "${var.apim.name}"
  resource_group_name = local.resourceGroupName
}

data "azurerm_resource_group" "rg" {
  name = local.resourceGroupName
}