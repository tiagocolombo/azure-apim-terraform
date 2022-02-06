locals {
  resourceGroupName  = "${var.prefix}-apim-${var.environment}-rg"
  appServicePlanName  = "${var.prefix}-${var.resourceFunction}-${var.environment}-plan"
  appServiceName  = "${var.prefix}-${var.resourceFunction}-${var.environment}-app"
}