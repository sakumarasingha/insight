@description('APIM name')
param apimName string

@description('Subscription Name')
param subscriptionName string

@description('Product Name')
param productName string

@description('Product Display Name')
param displayName string

resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' existing = {
  name: apimName
}

resource product 'Microsoft.ApiManagement/service/products@2023-03-01-preview' existing = {
  name: productName
}

resource subscription 'Microsoft.ApiManagement/service/subscriptions@2021-04-01-preview' = {
  parent: apim
  name: subscriptionName
  properties: {
    displayName: displayName
    state: 'active'
    scope: '/products/${product.id}'
  }
}
