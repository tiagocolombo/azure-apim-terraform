# Create Application Insights
resource "azurerm_application_insights" "ai" {
  name                = local.appInsightsName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  tags                = var.tags
}
# Create Logger
resource "azurerm_api_management_logger" "apimLogger" {
  name                = "${local.apimName}-logger"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name

  application_insights {
    instrumentation_key = azurerm_application_insights.ai.instrumentation_key
  }
}