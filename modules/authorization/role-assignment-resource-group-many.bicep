targetScope = 'managementGroup'

metadata name = 'Role Assignment to Resource Groups'
metadata description = 'Module used to assign a role to multiple Resource Groups'
metadata version = '1.0.0'

@description('A list of Resource Groups that will be used for role assignment in the format of subscriptionId/resourceGroupName (i.e. a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).')
param parResourceGroupIds array = []

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@description('Principal type of the assignee.  Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID')
param parAssigneeObjectId string

module modRoleAssignment 'role-assignment-resource-group.bicep' = [for resourceGroupId in parResourceGroupIds: {
  name: 'rbac-assign-${uniqueString(resourceGroupId, parAssigneeObjectId, parRoleDefinitionId)}'
  scope: resourceGroup(split(resourceGroupId, '/')[0], split(resourceGroupId, '/')[1])
  params: {
    parRoleAssignmentNameGuid: guid(resourceGroupId, parRoleDefinitionId, parAssigneeObjectId)
    parAssigneeObjectId: parAssigneeObjectId
    parAssigneePrincipalType: parAssigneePrincipalType
    parRoleDefinitionId: parRoleDefinitionId
  }
}]
