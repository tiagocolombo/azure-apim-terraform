# Get data reference to logged Azure subcription
data "azurerm_client_config" "data" {}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
  name     = local.resourceGroupName
  location = var.location
  tags     = var.tags
}

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

}

# Create Product for APIM management
resource "azurerm_api_management_product" "product" {
  product_id            = var.product.productId
  api_management_name   = azurerm_api_management.apim.name
  resource_group_name   = azurerm_resource_group.rg.name
  display_name          = var.product.productName
  subscription_required = var.product.subscriptionRequired
  subscriptions_limit   = var.product.subscriptionsLimit
  approval_required     = var.product.approvalRequired
  published             = var.product.published
}
# Set product policy
resource "azurerm_api_management_product_policy" "productPolicy" {
  product_id          = var.product.productId
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  xml_content = <<XML
    <policies>
      <inbound>
        <base />
      </inbound>
      <backend>
        <base />
      </backend>
      <outbound>
        <set-header name="Server" exists-action="delete" />
        <set-header name="X-Powered-By" exists-action="delete" />
        <set-header name="X-AspNet-Version" exists-action="delete" />
        <redirect-content-urls />
        <base />
      </outbound>
      <on-error>
        <base />
      </on-error>
    </policies>
  XML
  depends_on = [azurerm_api_management_product.product]
}

# Create Users
resource "azurerm_api_management_user" "user" {
  user_id             = "${azurerm_api_management_product.product.id}-user"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  first_name          = var.user.firstName
  last_name           = var.product.productName
  email               = var.user.email
  state               = "active"

  depends_on = [azurerm_api_management_product.product]
}

# Create subscription
resource "azurerm_api_management_subscription" "subscription" {
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  user_id             = azurerm_api_management_user.user.id
  product_id          = azurerm_api_management_product.product.id
  display_name        = var.subscription.subscriptionName
  state               = "active"

  depends_on = [
      azurerm_api_management_product.product,
      azurerm_api_management_user.user
  ]
}

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

  depends_on = [azurerm_api_management_product.product]
}