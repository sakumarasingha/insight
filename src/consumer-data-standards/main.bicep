// --------------------------------------------------------------
// Parameters
// --------------------------------------------------------------
@description('Name of the APIM instance')
param apimName string

@description('APIM resource group name')
param apimRgName string

@description('Api name')
param apiName string

@description('Api Display Name')
param apiDisplayName string

@description('Service description of the resource.')
param apiPath string

@description('Service URL.')
param apiServiceUrl string = ''

@description('API Description')
param apiDescription string = ''

@description('Service URL.')
param subscriptionRequired bool = true

@allowed([
  'graphql'
  'http'
  'odata'
  'soap'
  'websocket'
])
@description('Type of API')
param apiType string = 'http'

@allowed([
  'http'
  'https'
  'ws'
  'wss'
])
@description('Protocols the operations in this API can be invoked.')
param apiProtocols array = ['https']

@description('API Policy')
param apiPolicy string = ''

@allowed([
  'rawxml'
  'raw'
])
@description('API Policy Format')
param apiPolicyFormat string = 'raw'

@allowed([
'graphql-link'
'openapi'
'openapi+json'
'openapi+json-link'
'openapi-link'
'swagger-json'
'swagger-link-json'
'wadl-link-json'
'wadl-xml'
'wsdl'
'wsdl-link'
''
])
@description('Format of the Content in which the API is getting imported.')
param apiFormat string = ''

@description('API format content or link')
param apiFormatValue string = ''

// Deploy API to the APIM
module apim_api_main 'apim-api.bicep' = {
  name: 'deploy_apim_api'  
  params: {
    apimName: apimName
    apimRgName: apimRgName
    apiName: apiName
    apiDisplayName: apiDisplayName
    apiPath: apiPath
    apiServiceUrl: apiServiceUrl
    apiDescription: apiDescription
    subscriptionRequired: subscriptionRequired
    apiProtocols: apiProtocols
    apiPolicy: apiPolicy
    apiType: apiType
    apiPolicyFormat: apiPolicyFormat
    apiFormat: apiFormat
    apiFormatValue: apiFormatValue
  }
}
