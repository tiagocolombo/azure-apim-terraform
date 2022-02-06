locals {
  resourceGroupName  = "${var.prefix}-${var.resourceFunction}-${var.environment}-rg"
  storageAccountName = "${var.prefix}${var.resourceFunction}${var.environment}sa"  
  apimName          = "${var.prefix}-${var.resourceFunction}-${var.environment}-apim"
  kvName             = "${var.prefix}-${var.resourceFunction}-${var.environment}-kv"
  appInsightsName    = "${var.prefix}-${var.resourceFunction}-${var.environment}-ai"
}