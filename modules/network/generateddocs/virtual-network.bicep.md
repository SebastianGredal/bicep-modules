# Virtual Network Module

A module to deploy a Virtual Network

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPrefix      | No       | The Prefix to use for resource naming convention
parSuffix      | No       | The Suffix to use for resource naming convention
parName        | No       | The name of the resource
parLocation    | No       | The Azure Region to deploy the resources into.
parAddressPrefixes | Yes      | A list of address blocks reserved for this virtual network in CIDR notation.
parVirtualNetworkCommunity | No       | The BGP community associated with the virtual network.
parDdosProtectionPlanId | No       | The Resource Id of the DDoS Protection Plan associated with the virtual network.
parDnsServers  | No       | A list of DNS servers IP addresses. This should be a subset of the Virtual Network address space.
parEnableDdosProtection | No       | Indicates if DDoS protection is enabled for all the protected resources in the virtual network. It requires a DDoS protection plan associated with the resource.
parEnableVmProtection | No       | Indicates if VM protection is enabled for all the subnets in the virtual network.
parEncryption  | No       | Object that indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet. `enabled` - Boolean value indicating if encryption is enabled on the virtual network. `enforcement` - If the encrypted VNet allows VM that does not support encryption. Possible values are: 'AllowUnencrypted', 'DropUnencrypted'. 
parFlowTimeoutInMinutes | No       | The FlowTimeout value (in minutes) for the Virtual Network.
parIpAllocations | No       | Array of objects of IpAllocation which reference this VNET. Each object contains the resource id of the resource which is using this VNET.
parSubnets     | Yes      | Array of objects of subnets in a Virtual Network. Each object contains the properties of the subnet. Possible values are: `name` - The name of the subnet. `properties` - Object of the properties of the subnet. `properties.addressPrefix` - The address prefix for the subnet. `properties.applicationGatewayIPConfigurations` - An array of objects to the resource id of application gateway. `properties.defaultOutboundAccess` - Indicates whether default outbound rules are allowed or denied. Possible values are: 'true', 'false'. `properties.delegations` - An array of objects to the resource id of the delegations on the subnet. `properties.ipAllocations` - An array of objects to the resource id of the ip allocations on the subnet. `properties.natGateway` - An object referencing the resource id of the Nat Gateway. `properties.networkSecurityGroup` - An object referencing the resource id of the Network Security Group. `properties.privateEndpointNetworkPolicies` - Enable or Disable private endpoint network policies on the subnet. `properties.privateLinkServiceNetworkPolicies` - Enable or Disable private link service network policies on the subnet. `properties.routeTable` - An object referencing the resource id of the route table. `properties.serviceEndpointPolicies` - An array of objects to the resource id of the service endpoint policies on the subnet. `properties.serviceEndpoints` - An array of objects to the resource id of the service endpoints on the subnet. 
parVirtualNetworkPeerings | No       | Array of objects of Virtual Network Peerings. Each object contains the properties of the peering. Possible values are: 

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Prefix to use for resource naming convention

### parSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Suffix to use for resource naming convention

### parName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the resource

- Default value: `[format('{0}vnet{1}', parameters('parPrefix'), parameters('parSuffix'))]`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parAddressPrefixes

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

A list of address blocks reserved for this virtual network in CIDR notation.

### parVirtualNetworkCommunity

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The BGP community associated with the virtual network.

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Resource Id of the DDoS Protection Plan associated with the virtual network.

### parDnsServers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A list of DNS servers IP addresses. This should be a subset of the Virtual Network address space.

### parEnableDdosProtection

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Indicates if DDoS protection is enabled for all the protected resources in the virtual network. It requires a DDoS protection plan associated with the resource.

- Default value: `False`

### parEnableVmProtection

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Indicates if VM protection is enabled for all the subnets in the virtual network.

- Default value: `False`

### parEncryption

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object that indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet.
`enabled` - Boolean value indicating if encryption is enabled on the virtual network.
`enforcement` - If the encrypted VNet allows VM that does not support encryption. Possible values are: 'AllowUnencrypted', 'DropUnencrypted'.


### parFlowTimeoutInMinutes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The FlowTimeout value (in minutes) for the Virtual Network.

- Default value: `-1`

### parIpAllocations

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects of IpAllocation which reference this VNET. Each object contains the resource id of the resource which is using this VNET.

### parSubnets

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Array of objects of subnets in a Virtual Network. Each object contains the properties of the subnet. Possible values are:
`name` - The name of the subnet.
`properties` - Object of the properties of the subnet.
`properties.addressPrefix` - The address prefix for the subnet.
`properties.applicationGatewayIPConfigurations` - An array of objects to the resource id of application gateway.
`properties.defaultOutboundAccess` - Indicates whether default outbound rules are allowed or denied. Possible values are: 'true', 'false'.
`properties.delegations` - An array of objects to the resource id of the delegations on the subnet.
`properties.ipAllocations` - An array of objects to the resource id of the ip allocations on the subnet.
`properties.natGateway` - An object referencing the resource id of the Nat Gateway.
`properties.networkSecurityGroup` - An object referencing the resource id of the Network Security Group.
`properties.privateEndpointNetworkPolicies` - Enable or Disable private endpoint network policies on the subnet.
`properties.privateLinkServiceNetworkPolicies` - Enable or Disable private link service network policies on the subnet.
`properties.routeTable` - An object referencing the resource id of the route table.
`properties.serviceEndpointPolicies` - An array of objects to the resource id of the service endpoint policies on the subnet.
`properties.serviceEndpoints` - An array of objects to the resource id of the service endpoints on the subnet.


### parVirtualNetworkPeerings

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects of Virtual Network Peerings. Each object contains the properties of the peering. Possible values are:


## Outputs

Name | Type | Description
---- | ---- | -----------
outVirtualNetworkId | string | The Id of the Virtual Network
outVirtualNetworkName | string | The Name of the Virtual Network
outVirtualNetworkSubnets | object | The Id and Name of the Virtual Network Subnets

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "modules/network/virtual-network.json"
    },
    "parameters": {
        "parPrefix": {
            "value": ""
        },
        "parSuffix": {
            "value": ""
        },
        "parName": {
            "value": "[format('{0}vnet{1}', parameters('parPrefix'), parameters('parSuffix'))]"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parAddressPrefixes": {
            "value": []
        },
        "parVirtualNetworkCommunity": {
            "value": ""
        },
        "parDdosProtectionPlanId": {
            "value": ""
        },
        "parDnsServers": {
            "value": []
        },
        "parEnableDdosProtection": {
            "value": false
        },
        "parEnableVmProtection": {
            "value": false
        },
        "parEncryption": {
            "value": {}
        },
        "parFlowTimeoutInMinutes": {
            "value": -1
        },
        "parIpAllocations": {
            "value": []
        },
        "parSubnets": {
            "value": []
        },
        "parVirtualNetworkPeerings": {
            "value": []
        }
    }
}
```
