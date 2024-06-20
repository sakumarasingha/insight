@description('Name of the APIM.')
param apimName string 

@description('NamedValue Name')
param name string 

@description('NamedValue value.')
param value string = ''

@description('NamedValue Display Name')
param displayName string 

@description('Publisher Email')
param isSecret bool  = true

@secure()
@description('KeyVault Name')
param secretIdentifier string = ''


resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' existing ={
  name: apimName
}

resource apim_namedvalues 'Microsoft.ApiManagement/service/namedValues@2023-03-01-preview' =  {
  parent: apim
  name: name
  properties: {
    displayName: displayName
    secret: isSecret
    value:  !empty(value)? value : null 
    keyVault:!empty(secretIdentifier) ? {
      secretIdentifier: secretIdentifier
    }: null
    tags: [
      name
    ]
  }
}
