using '../main.bicep'
param apimName = 'apim-integration-dev-ase-002'
param apimRgName = 'rg-integration-core-dev-ase-001'
param apiName = 'cds-banking-api'
param apiDisplayName = 'CDS Banking API'
param apiPath = 'cds'
param apiDescription = 'Consumer Data Standards API'
param apiPolicy = loadTextContent('../artifacts/api-policy.xml')
param apiPolicyFormat = 'rawxml'
param apiFormat = 'openapi-link'
param apiFormatValue = 'https://consumerdatastandardsaustralia.github.io/standards/includes/swagger/cds_banking.yaml'
param subscriptionRequired = false
