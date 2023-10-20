# Role Assignment to Tenant

Module used to assign a role to the Tenant Root Group

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parRoleAssignmentNameGuid | No       | A GUID representing the role assignment name.
parRoleDefinitionId | Yes      | Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)
parAssigneePrincipalType | Yes      | Principal type of the assignee.
parAssigneeObjectId | Yes      | Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID

### parRoleAssignmentNameGuid

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A GUID representing the role assignment name.

- Default value: `[guid(tenant().tenantId, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]`

### parRoleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)

### parAssigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Principal type of the assignee.

- Allowed values: `Group`, `ServicePrincipal`

### parAssigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "modules/authorization/role-assignment-tenant.json"
    },
    "parameters": {
        "parRoleAssignmentNameGuid": {
            "value": "[guid(tenant().tenantId, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]"
        },
        "parRoleDefinitionId": {
            "value": ""
        },
        "parAssigneePrincipalType": {
            "value": ""
        },
        "parAssigneeObjectId": {
            "value": ""
        }
    }
}
```
