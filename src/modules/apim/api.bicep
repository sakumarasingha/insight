@description('APIM name')
param apimName string

@description('Api name')
param apiName string

@description('Api Display Name')
param apiDisplayName string

@description('Service description of the resource.')
param apiPath string

@description('Backend URL.')
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

resource apimApi 'Microsoft.ApiManagement/service/apis@2022-04-01-preview' = {
  name: '${apimName}/${apiName}'
  properties: {
    displayName: apiDisplayName
    path: apiPath
    subscriptionRequired: subscriptionRequired
    apiType: apiType
    description: apiDescription
    protocols: apiProtocols
    subscriptionKeyParameterNames: {
      header: 'ApiKey'
      query: 'api-key'
    }
    format: !empty(apiFormat) ? apiFormat : null
    value: !empty(apiFormat) ? apiFormatValue : null
  }
}

resource apiPolicies 'Microsoft.ApiManagement/service/apis/policies@2023-03-01-preview' =
  if (!empty(apiPolicy)) {
    name: 'policy'
    parent: apimApi
    properties: {
      value: apiPolicy
      format: apiPolicyFormat
    }
  }

/*
resource apiMonitoring 'Microsoft.ApiManagement/service/apis/diagnostics@2020-06-01-preview' = {
  name: '${apimApi}/applicationinsights'
  properties: {
    alwaysLog: 'allErrors'
    loggerId: logger.id  
    logClientIp: true
    httpCorrelationProtocol: 'W3C'
    verbosity: 'information'
    operationNameFormat: 'Url'
  }
}
*/
output apiResourceId string = apimApi.id
