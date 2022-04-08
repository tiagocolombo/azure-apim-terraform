<!--replace this with Properties and Tags sections. These are required sections. See "article-metadata.md" in under the "contributor-guide" folder in your repo. Attributes in each section can be placed on separate lines to make them easier to read and check-->

# Create an Azure API Management Services using Terraform
This article shows you how to create an APIM (Azure APIM Manahement Services), using commands and configuration files in Terraform. This is intended to help you structure and deploy a new APIM resource as well as configuring to receive new API endpoints.

## Prerequisite: Install a Recent Version of Azure CLI and Terraform
If you haven't done so already, install at least the 2.35.0 version of Azure CLI on your local computer, and at least the 1.1.0 version of Terraform. For details, see:

* [How to update the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/update-azure-cli) for instructions on how to update the Azure CLI version.
* [How to install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) for instructions on how to install the Azure CLI if you don't have it.
* [Install Azure Terraform](https://www.terraform.io/downloads) for instructions on how to install and config Terraform.

> [!NOTE]
> Without proper versions installed, you might encounter errors when executing the Terraform commands
> 

## Azure Resources
This table shows the list of Azure resources needed to have the APIM setup.

| Resource | Terraform Name | Description |
| --- | --- | --- |
| Resource Group |`azurerm_resource_group` | Required for creating any resource in Azure |
| APIM |`azurerm_api_management` | Management platform for APIs  |
| Application Insights |`azurerm_application_insights` | Log management service for APIM logs  |

## Azure API Management terminology
This section gives definitions for the terms that are specific to API Management (APIM).

* **Backend API** - An HTTP service that implements your API and its operations. For more information, see [Backends](https://docs.microsoft.com/en-ca/azure/api-management/backends).
* **Frontend API/APIM API** - An APIM API does not host APIs, it creates façades for your APIs. You customize the façade according to your needs without touching the backend API. For more information, see [Import and publish an API](https://docs.microsoft.com/en-ca/azure/api-management/import-and-publish).
* **APIM product** - a product contains one or more APIs as well as a usage quota and the terms of use. You can include a number of APIs and offer them to developers through the Developer portal. For more information, see [Create and publish a product](https://docs.microsoft.com/en-ca/azure/api-management/api-management-howto-add-products).
* **APIM API operation** - Each APIM API represents a set of operations available to developers. Each APIM API contains a reference to the backend service that implements the API, and its operations map to the operations implemented by the backend service. For more information, see [Mock API responses](https://docs.microsoft.com/en-ca/azure/api-management/mock-api-responses).
* **Version** - Sometimes you want to publish new or different API features to some users, while others want to stick with the API that currently works for them. For more information, see [Publish multiple versions of your API](https://docs.microsoft.com/en-ca/azure/api-management/api-management-get-started-publish-versions).
* **Revision** - When your API is ready to go and starts to be used by developers, you usually need to take care in making changes to that API and at the same time not to disrupt callers of your API. It's also useful to let developers know about the changes you made. For more information, see [Use revisions](https://docs.microsoft.com/en-ca/azure/api-management/api-management-get-started-revise-api).
* **Developer portal** - Customers, like developers, should use the Developer portal to access your APIs. The Developer portal can be customized. For more information, see [Customize the Developer portal](https://docs.microsoft.com/en-ca/azure/api-management/api-management-customize-styles).

* **APIM Subscription**: Subscriptions are the most common way for API consumers to access APIs published through an API Management instance. Developers and applications which need to consume the published APIs must include a valid subscription key in HTTP requests when calling those APIs. Without a valid subscription key, the calls are: rejected immediately by the API Management gateway and not forwarded to the back-end services. For more information, see [Subscriptions in APIM](https://docs.microsoft.com/en-us/azure/api-management/api-management-subscriptions).

* **APIM Developers (or Users)**: Represent the user accounts in an API Management service instance, and they are the link between a product and a subscription.

* **APIM Policies**: With policies, an API publisher can change the behavior of an API through configuration. Policies are a collection of statements that are executed sequentially on the request or response of an API. Popular statements include format conversion from XML to JSON and call-rate limiting to restrict the number of incoming calls from a developer. For a complete list, see [API Management policies](https://docs.microsoft.com/en-us/azure/api-management/api-management-policies).

![APIM structure](https://docs.microsoft.com/en-us/azure/api-management/media/api-management-subscriptions/product-subscription.png)

**Source**: https://docs.microsoft.com/en-ca/azure/api-management/api-management-terminology#term-definitions

For more information about APIM, you can find [here](https://azure.microsoft.com/en-us/services/api-management/#overview).

## Configuration
Find in the [`variables.tf`](variables.tf) file the list of variables used to create and config the API. 

By using `tfvars`, you can define different values for the variables according to each environment. In this case, we have a file `tc-apim.dev.tfvars` created to deploy an APIM service to Azure in a `dev` environment.

### APIM Skus (or Tiers)
* **Consumption**: The serverless consumption tier plan lets you pay for what you use, rather than having dedicated resources. You can quickly set up ad-hoc testing and you can upscale your API access when your demand increases. The consumption tier has a built-in high availability and autoscaling. It’s delivered very fast because it doesn’t need to reserve many resources upfront (the hosted tiers have an average delivery time between 30 and 45 min).
* **Developer**: Use the developer tier for evaluating the API management service or for lower environments. Note: Don't use this tier for production deployments.
* **Basic, Standard & Premium**: These three tiers are production level tiers that go from entry-level production to medium-volume production and finally high-volume or enterprise production use. 

Find more about the different tiers and features [here](https://docs.microsoft.com/en-us/azure/api-management/api-management-features), and about pricing [here](https://azure.microsoft.com/en-us/pricing/details/api-management/#pricing).

The current configuration is defined to use the **Consumption** plan and should be enough for test purposes.

## Deploy and Test
This section gives the instructions on how to deploy the APIM service to Azure from your CLI.

### Deploy using the CLI
Follow these steps in order to setup the API services to your Azure subscription.

* Log in to Azure using `azure cli` or Azure Cloud Shell
* Set your subscription by running the following command: `az account set -s "{subscription_id}"`
* Run `terraform init`, and then, run `terraform plan -var-file="tfvars/tc-apim.dev.tfvars"`
* If there's no errors, run `terraform apply -var-file="tfvars/tc-apim.dev.tfvars"` to create the resources in Azure.

## Additional Resources
[Protect your API](https://docs.microsoft.com/en-us/azure/api-management/transform-api)

[Debug APIM policies using VS Code](https://docs.microsoft.com/en-us/azure/api-management/api-management-debug-policies)

[API Management advanced policies](https://docs.microsoft.com/en-us/azure/api-management/api-management-advanced-policies)