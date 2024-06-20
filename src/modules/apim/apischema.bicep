@description('APIM name')
param apimName string

@description('API Name')
param apiName string

@description('Operation Name')
param name string

@description('Schema Definition')
param schema object = {}

resource apiSchemaGuid 'Microsoft.ApiManagement/service/apis/schemas@2023-03-01-preview' = {
  name: '${apimName}/${apiName}/${name}'
  properties: {
    contentType: 'application/vnd.oai.openapi.components+json'    
    document: schema
  }
}

output schemaIdId string = apiSchemaGuid.id
