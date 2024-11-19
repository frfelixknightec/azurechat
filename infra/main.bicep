targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param name string 

@minLength(1)
@description('Primary location for all resources')
param location string

//Testing to add tags manually
@minLength(1)
@description('Contact person for resource group')
param mail string = 'Andrey.Alishev@knightec.se'

//Testing to add tags manually
@minLength(1)
@description('Contact person 2 for resource group')
param mail2 string = 'felix.fredin@knightec.se'

// azure open ai -- regions currently support gpt-4o global-standard
@description('Location for the OpenAI resource group')
@allowed(['australiaeast', 'brazilsouth', 'canadaeast', 'eastus', 'eastus2', 'francecentral', 'germanywestcentral', 'japaneast', 'koreacentral', 'northcentralus', 'norwayeast', 'polandcentral', 'spaincentral', 'southafricanorth', 'southcentralus', 'southindia', 'swedencentral', 'switzerlandnorth', 'uksouth', 'westeurope', 'westus', 'westus3'])
@metadata({
  azd: {
    type: 'location'
  }
})
param openAILocation string

param openAISku string = 'S0'
param openAIApiVersion string ='2024-08-01-preview'

param chatGptDeploymentCapacity int = 10
param chatGptDeploymentName string = 'gpt-4o'
param chatGptModelName string = 'gpt-4o'
param chatGptModelVersion string = '2024-05-13'
param embeddingDeploymentName string = 'embedding'
param embeddingDeploymentCapacity int = 80 
param embeddingModelName string = 'text-embedding-3-large'

// DALL-E v3 only supported in limited regions for now
@description('Location for the OpenAI DALL-E 3 instance resource group')
@allowed(['swedencentral', 'eastus', 'australiaeast'])
param dalleLocation string

param dalleDeploymentCapacity int = 1
param dalleDeploymentName string = 'dall-e-3'
param dalleModelName string = 'dall-e-3'
param dalleApiVersion string = '2023-12-01-preview'

param formRecognizerSkuName string = 'S0'
param searchServiceIndexName string = 'azure-chat'
param searchServiceSkuName string = 'basic'

// TODO: define good default Sku and settings for storage account
param storageServiceSku object = { name: 'Standard_LRS' } 
param storageServiceImageContainerName string = 'images'

param resourceGroupName string = ''

var resourceToken = 'unique420'//toLower(uniqueString(subscription().id, name, location)) //Trying to remove uniqueString
var tags = { 
          'azd-dnv-name': name
          'Contact': mail
          'Contact2': mail2
          } //Test to see if multiple tags can be added

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : 'rg-${name}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  name: 'all-resources'
  scope: rg
  params: {
    name: name
    resourceToken: resourceToken
    tags: tags
    openai_api_version: openAIApiVersion
    openAiLocation: openAILocation
    openAiSkuName: openAISku
    chatGptDeploymentCapacity: chatGptDeploymentCapacity
    chatGptDeploymentName: chatGptDeploymentName
    chatGptModelName: chatGptModelName
    chatGptModelVersion: chatGptModelVersion
    embeddingDeploymentName: embeddingDeploymentName
    embeddingDeploymentCapacity: embeddingDeploymentCapacity
    embeddingModelName: embeddingModelName
    dalleLocation: dalleLocation
    dalleDeploymentCapacity: dalleDeploymentCapacity
    dalleDeploymentName: dalleDeploymentName
    dalleModelName: dalleModelName
    dalleApiVersion: dalleApiVersion
    formRecognizerSkuName: formRecognizerSkuName
    searchServiceIndexName: searchServiceIndexName
    searchServiceSkuName: searchServiceSkuName
    storageServiceSku: storageServiceSku
    storageServiceImageContainerName: storageServiceImageContainerName
    location: location
  }
}

//output APP_URL string = resources.outputs.url
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
