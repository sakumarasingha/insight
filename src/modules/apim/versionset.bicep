@description('API Name')
param apimName string

@description('VersionSet Name')
param name string

@description('VersionSet Display Name')
param displayName string

@description('VersioningScheme')
@allowed([
  'Segment'
  'Header'
  'Query'
])
param versioningScheme string = 'Segment'

resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' existing = {
  name: apimName
}

resource apiVersionset 'Microsoft.ApiManagement/service/apiVersionSets@2023-03-01-preview' = {
  name: name
  parent: apim
  properties: {
    displayName: displayName
    versioningScheme:versioningScheme
  }
}

output versionSetId string = apiVersionset.id
