@description('APIM name')
param apimName string

@description('Operation Name')
param name string

@description('Schema Definition')
param schema object = {}

resource apim_schema 'Microsoft.ApiManagement/service/schemas@2023-03-01-preview' = {
  name: '${apimName}/${name}'
  properties: {
    schemaType: 'json'
    document: schema
  }
}

output schemaIdId string = apim_schema.id
