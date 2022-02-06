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
        <base />
      </outbound>
      <on-error>
        <base />
      </on-error>
    </policies>
  XML
  depends_on = [azurerm_api_management_product.product]
}