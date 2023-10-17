targetScope = 'resourceGroup'

metadata name = 'Virtual Network Module'
metadata description = 'A module to deploy a Virtual Network'
metadata version = '1.0.0'

// ----------
// PARAMETERS
// ----------
@description('The Prefix to use for the naming convention')
param parPrefix string = ''

@description('The Suffix to use for the naming convention')
param parSuffix string = ''

@description('The name of the resource')
param parName string = '${parPrefix}vnet${parSuffix}'

@description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@description('A list of address blocks reserved for this virtual network in CIDR notation.')
param parAddressPrefixes array

@description('The BGP community associated with the virtual network.')
param parVirtualNetworkCommunity string = ''

@description('The Resource Id of the DDoS Protection Plan associated with the virtual network.')
param parDdosProtectionPlanId string = ''

@description('A list of DNS servers IP addresses. This should be a subset of the Virtual Network address space.')
param parDnsServers array = []

@description('Indicates if VM protection is enabled for all the subnets in the virtual network.')
param parEnableVmProtection bool = false

@description('''Object that indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet.
`enabled` - Boolean value indicating if encryption is enabled on the virtual network.
`enforcement` - If the encrypted VNet allows VM that does not support encryption. Possible values are: 'AllowUnencrypted', 'DropUnencrypted'.
''')
param parEncryption object = {}

@description('The FlowTimeout value (in minutes) for the Virtual Network.')
param parFlowTimeoutInMinutes int = -1

@description('Array of objects of IpAllocation which reference this VNET. Each object contains the resource id of the resource which is using this VNET.')
param parIpAllocations array = []

@description('''Array of objects of subnets in a Virtual Network. Each object contains the properties of the subnet. Possible values are:
`name` - The name of the subnet.
`properties` - Properties of the subnet.
`properties.addressPrefix` - The address prefix for the subnet.
`properties.applicationGatewayIPConfigurations` - An array of objects to the resource id of application gateway.
`properties.defaultOutboundAccess` - Indicates whether default outbound rules are allowed or denied. Possible values are: 'true', 'false'.
`properties.delegations` - An array of objects to the resource id of the delegations on the subnet.
`properties.ipAllocations` - An array of objects to the resource id of the ip allocations on the subnet.
`properties.natGateway` - An object referencing the resource id of the Nat Gateway.
`properties.networkSecurityGroup` - An object referencing the resource id of the Network Security Group.
`properties.privateEndpointNetworkPolicies` - Enable or Disable private endpoint network policies on the subnet.
- Possible values are: 'Enabled', 'Disabled'.  
- Default Value: 'Disabled'.
`properties.privateLinkServiceNetworkPolicies` - Enable or Disable private link service network policies on the subnet.
- Possible values are: 'Enabled', 'Disabled'.
- Default Value: 'Enabled'
`properties.routeTable` - An object referencing the resource id of the route table.
`properties.serviceEndpointPolicies` - An array of objects to the resource id of the service endpoint policies on the subnet.
`properties.serviceEndpoints` - An array of objects to the resource id of the service endpoints on the subnet.
''')
param parSubnets array

@description('''Array of objects of Virtual Network Peerings. Each object contains the properties of the peering. Possible values are:
''')
param parVirtualNetworkPeerings array = []

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------
resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: parName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: parAddressPrefixes
    }
    bgpCommunities: empty(parVirtualNetworkCommunity) ? null : {
      virtualNetworkCommunity: parVirtualNetworkCommunity
    }
    ddosProtectionPlan: empty(parDdosProtectionPlanId) ? null : {
      id: parDdosProtectionPlanId
    }
    dhcpOptions: empty(parDnsServers) ? null : {
      dnsServers: parDnsServers
    }
    enableDdosProtection: !empty(parDdosProtectionPlanId)
    enableVmProtection: parEnableVmProtection
    encryption: empty(parEncryption) ? null : {
      enabled: parEncryption.enabled
      enforcement: parEncryption.enforcement
    }
    flowTimeoutInMinutes: parFlowTimeoutInMinutes == -1 ? null : parFlowTimeoutInMinutes
    ipAllocations: empty(parIpAllocations) ? null : parIpAllocations
    subnets: parSubnets
    virtualNetworkPeerings: empty(parVirtualNetworkPeerings) ? null : parVirtualNetworkPeerings
  }
}

// resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
//   name: parName
//   location: parLocation
//   properties: {
//     addressSpace: {
//       addressPrefixes: []
//     }
//     subnets: [
//       {
//         name: ''
//         properties: {
//           addressPrefix: ''
//           applicationGatewayIPConfigurations: [
//             {
//               id: ''
//             }
//           ]
//           defaultOutboundAccess: false
//           delegations: []
//           ipAllocations: []
//           natGateway: {
//             id: ''
//           }
//           networkSecurityGroup: {
//             id: ''
//           }
//           privateEndpointNetworkPolicies: 'Enabled'
//           privateLinkServiceNetworkPolicies: 'Enabled'
//           routeTable: {
//             id: ''
//           }
//           serviceEndpointPolicies: [
//             {
//               properties: 
//             }
//           ]
//           serviceEndpoints: [
//             {

//             }
//           ]
//         }
//       }
//     ]
//   }
// }

// ----------
//  OUTPUTS
// ----------
output outVirtualNetworkId string = resVirtualNetwork.id
