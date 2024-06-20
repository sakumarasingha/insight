
@description('APIM name')
param apimName string

@description('API Name')
param apiName string

@description('Operation Name')
param name string

@description('Operation Display Name')
param displayName string

@description('Operation Level Policies')
param policy string = ''

@description('Http Verb')
param method string 

@description('Http Operation')
param urlPath string 

@description('Template Parameters')
param templateParams array = [] 

@description('Policy Format')
param policyFormat string = 'xml'

@description('Http Operation')
param opSchemaGuid string = ''

@description('Operation Schema Type')
param opSchemaType string = ''

resource api 'Microsoft.ApiManagement/service/apis@2022-04-01-preview' existing ={
  name: apiName
}

resource apiOperation 'Microsoft.ApiManagement/service/apis/operations@2023-03-01-preview' = {
  name: '${apimName}/${apiName}/${name}'
  properties: {
    displayName: displayName
    method: method
    urlTemplate: urlPath    
    templateParameters: templateParams
    request:{
      queryParameters: []
      headers: []
      representations: [
        {
          contentType: 'application/json'    
          schemaId: !empty(opSchemaGuid)? opSchemaGuid : null
          typeName: !empty(opSchemaType)? opSchemaType : null     
        }
      ]
    }
    responses: []
  }
  dependsOn:[
    api
  ]
}

resource apiPolicies 'Microsoft.ApiManagement/service/apis/operations/policies@2023-03-01-preview' = if (!empty(policy)) {
  name: 'policy'
  parent: apiOperation
  properties: {
    value: policy
    format: policyFormat
  }
}
