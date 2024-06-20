@description('Api name')
param apimName string

@description('Api name')
param apiName string

@description('Api Operation Name')
param operationName string

@description('Api Operation Name')
param policyContent string

resource updateOperationPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2023-03-01-preview' = {
  name: '${apimName}/${apiName}/${operationName}/policy'
  //parent: operations[0]
  properties: {
    format: 'rawxml'
    value: policyContent
  }
}
