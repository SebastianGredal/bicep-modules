targetScope = 'resourceGroup'

metadata name = 'Role Assignment to a Resource Group'
metadata description = 'Module used to assign a role to a Resource Group'
metadata version = '1.0.0'

@description('A GUID representing the role assignment name.')
param parRoleAssignmentNameGuid string = guid(resourceGroup().id, parRoleDefinitionId, parAssigneeObjectId)

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@description('Principal type of the assignee. Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID')
param parAssigneeObjectId string

resource resRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: parRoleAssignmentNameGuid
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', parRoleDefinitionId)
    principalId: parAssigneeObjectId
    principalType: parAssigneePrincipalType
  }
}
