Create APIM (Azure API Management Services) in Azure

1. Log in to Azure using `azure cli` or Azure Cloud Shell
2. Root to the folder `azure_apim`, and run `terraform plan -var-file="tfvars/tc-apim.dev.tfvars"`
3. To create the resources in Azure, run `terraform apply -var-file="tfvars/tc-apim.dev.tfvars"`. This will create the resources defined in the terraform files.

Credits: https://www.jeanpaulsmit.com/2020/03/terraform-deploy-apim/