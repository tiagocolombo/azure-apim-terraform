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

# Create a new policy - it will be applied for all APIs 
resource "azurerm_api_management_policy" "apim_policy" {
  api_management_id = azurerm_api_management.apim.id
  xml_content       =  <<XML
    <!--
        IMPORTANT:
        - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
        - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
        - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
        - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.
        - To remove a policy, delete the corresponding policy statement from the policy document.
        - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.
        - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.
        - Policies are applied in the order of their appearance, from the top down.
        - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.
    -->
    <policies>
        <inbound />
        <backend>
            <forward-request />
        </backend>
        <outbound>
            <set-header name="Strict-Transport-Security" exists-action="override">
                <value>max-age=31536000; includeSubDomains</value>
            </set-header>
            <set-header name="X-XSS-Protection" exists-action="override">
                <value>1; mode=block</value>
            </set-header>
            <set-header name="Content-Security-Policy" exists-action="override">
                <value>script-src 'self'</value>
            </set-header>
            <set-header name="X-Frame-Options" exists-action="override">
                <value>SAMEORIGIN</value>
            </set-header>
            <set-header name="X-Content-Type-Options" exists-action="override">
                <value>nosniff</value>
            </set-header>
            <set-header name="Expect-Ct" exists-action="override">
                <value>max-age=604800,enforce</value>
            </set-header>
            <set-header name="Cache-Control" exists-action="override">
                <value>none</value>
            </set-header>
            <set-header name="Server" exists-action="delete" />
            <set-header name="X-Powered-By" exists-action="delete" />
            <set-header name="X-AspNet-Version" exists-action="delete" />
            <redirect-content-urls />
        </outbound>
        <on-error />
    </policies>
  XML

  depends_on = [azurerm_api_management.apim]
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

# Create Users - not available for Consumption plan
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