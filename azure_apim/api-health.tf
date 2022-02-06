# Create API
resource "azurerm_api_management_api" "apiHealthProbe" {
name                = "health-probe"
resource_group_name = azurerm_resource_group.rg.name
api_management_name = azurerm_api_management.apim.name
revision            = "1"
display_name        = "Health probe"
path                = "health-probe"
protocols           = ["https"]

  subscription_key_parameter_names  {
    header = "Ocp-Apim-Subscription-Key"
    query = "subscription-key"
  }

  import {
    content_format = "swagger-json"
    content_value  = <<JSON
      {
          "swagger": "2.0",
          "info": {
              "version": "1.0.0",
              "title": "Health probe"
          },
          "host": "not-used-direct-response",
          "basePath": "/",
          "schemes": [
              "https"
          ],
          "consumes": [
              "application/json"
          ],
          "produces": [
              "application/json"
          ],
          "paths": {
              "/": {
                  "get": {
                      "operationId": "get-ping",
                      "responses": {}
                  }
              }
          }
      }
    JSON
  }
}
# set api level policy
resource "azurerm_api_management_api_policy" "apiHealthProbePolicy" {
  api_name            = azurerm_api_management_api.apiHealthProbe.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name

  xml_content = <<XML
    <policies>
      <inbound>
        <return-response>
            <set-status code="200" />
            <set-body>Ping OK!</set-body>
        </return-response>
        <base />
      </inbound>
    </policies>
  XML
}
# Assign API to Management product in APIM
resource "azurerm_api_management_product_api" "apiProduct" {
  api_name            = azurerm_api_management_api.apiHealthProbe.name
  product_id          = azurerm_api_management_product.product.product_id
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
}