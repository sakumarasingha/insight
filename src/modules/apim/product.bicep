@description('APIM name')
param apimName string

@description('Product Name')
param productName string

@description('Product Display Name')
param displayName string

@description('Product Level Policies')
param productPolicy string = ''

resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' existing = {
  name: apimName
}

resource product 'Microsoft.ApiManagement/service/products@2023-03-01-preview' = {
  parent: apim
  name: productName
  properties: {
    approvalRequired: false
    subscriptionRequired: true
    displayName: displayName
    state: 'published'
  }
}

resource basicProductPolicies 'Microsoft.ApiManagement/service/products/policies@2020-12-01' = if (!empty(productPolicy)) {
  name: 'policy'
  parent: product
  properties: {
    value: productPolicy
    format: 'xml'
  }
}

output productId string = product.id
