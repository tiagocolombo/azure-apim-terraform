# Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = local.appServicePlanName
  location            = var.location
  tags                = var.tags
  resource_group_name = data.azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}
# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_app_service" "webapp" {
  name                = local.appServiceName
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  source_control {
    repo_url           = "https://github.com/Azure-Samples/dotnet-core-api"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}