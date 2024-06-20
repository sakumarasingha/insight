@description('Location of the resource.')
param location string = resourceGroup().location

@description('Name of the APIM.')
param apimName string 

@description('SKU of the APIM.')
param apimSku string 

@description('Publisher Name')
param publisherName string 

@description('Publisher Email')
param publisherEmail string 

@description('Tag list and values')
param tagList object = {}

@description('Number of scale units')
param scaleUnits int = 1

@description('Virtual Network Type')
@allowed([
  'External'
  'Internal'
  'None'
])
param networkType string 

@description('Public endpoint access is allowed or not')
param publicNetworkAccess string = 'Enabled'

@description('Name of the appservice plan.')
param appinsightName string 

resource appinsight 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appinsightName
}

@description('VNET Name')
param vnetName string

@description('VNET RG Name')
param vnetRgName string

@description('Subnet Name')
param subnetName string

@description('Workspace Id for diagnostics ')
param omsWorkspaceId string = ''

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetRgName)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' existing = {
  name: subnetName
  parent: vnet
}

resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: apimName
  tags: tagList
  location: location
  sku:{
    capacity: scaleUnits
    name: apimSku
  }
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    publisherName: publisherName
    publisherEmail: publisherEmail
    virtualNetworkType: networkType
    publicNetworkAccess: publicNetworkAccess
    virtualNetworkConfiguration: (networkType=='None')? null :{
      subnetResourceId: subnet.id
    }
    apiVersionConstraint:{
      minApiVersion:'2021-08-01'
    }
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'True'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
    }
  }
}

resource appInsightsAPIManagement 'Microsoft.ApiManagement/service/loggers@2023-03-01-preview' = {
  parent: apim
  name: appinsightName
  properties: {
    loggerType: 'applicationInsights'
    description: 'Integration Insights instance.'
    resourceId: appinsight.id
    credentials: {
      instrumentationKey: appinsight.properties.InstrumentationKey
    }
  }
}

resource apimName_microsoft_insights_diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(omsWorkspaceId)) {
  name: '${apimName}-diagnosticSetting'
  properties: {
    workspaceId: omsWorkspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    logs: [
      {
        category: 'GatewayLogs'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
  dependsOn: []
}

output apimObjectId string = apim.identity.principalId
output resourceId string = apim.id
