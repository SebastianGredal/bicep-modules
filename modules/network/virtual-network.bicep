targetScope = 'resourceGroup'

metadata name = 'Virtual Network Module'
metadata description = 'A module used for the deployment of a Virtual Network resource.'
metadata version = '1.0.0'

// ----------
// PARAMETERS
// ----------
@description('The Prefix to use for resource naming convention.')
param parPrefix string = ''

@description('The Suffix to use for resource naming convention.')
param parSuffix string = ''

@description('The name of the resource.')
param parName string = '${parPrefix}vnet${parSuffix}'

@description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@description('A list of address blocks reserved for this Virtual Network in CIDR notation.')
param parAddressPrefixes array

@description('The BGP community associated with the Virtual Network.')
param parVirtualNetworkCommunity string = ''

@description('The Resource Id of the DDoS Protection Plan associated with the Virtual Network.')
param parDdosProtectionPlanId string = ''

@description('A list of DNS servers IP addresses. This should be a subset of the Virtual Network address space.')
param parDnsServers array = []

@description('Indicates if DDoS protection is enabled for all the protected resources in the Virtual Network. It requires a DDoS protection plan associated with the resource.')
param parEnableDdosProtection bool = false

@description('Indicates if VM protection is enabled for all the subnets in the Virtual Network.')
param parEnableVmProtection bool = false

@description('''Object that indicates if encryption is enabled on Virtual Network and if VM without encryption is allowed in encrypted Virtual Network.
`enabled` - Boolean value indicating if encryption is enabled on the Virtual Network.
`enforcement` - If the encrypted Virtual Network allows VM's that does not support encryption. Possible values are: 'AllowUnencrypted', 'DropUnencrypted'.
''')
param parEncryption object = {}

@minValue(3)
@maxValue(30)
@description('The FlowTimeout value (in minutes) for the Virtual Network. Set Value to 3 to disable FlowTimeout.')
param parFlowTimeoutInMinutes int = 3

@description('Array of objects of IpAllocation which reference this Virtual Network. Each object contains the resource id of the resource which is using this Virtual Network.')
param parIpAllocations array = []

@description('''Array of objects of subnets in a Virtual Network. Each object contains the properties of the subnet. Possible values are:
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
''')
param parSubnets array

@description('Array of objects of Virtual Network Peerings. Each object contains the properties of the peering.')
param parVirtualNetworkPeerings array = []

// ---------
// VARIABLES
// ---------
var varVirtualNetworkSubnets = reduce(resVirtualNetwork.properties.subnets, {}, (result, subnet) => union(result, { '${subnet.name}': {
        id: subnet.id
        name: subnet.name
      }
    }
  )
)

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
    enableDdosProtection: empty(parDdosProtectionPlanId) ? null : parEnableDdosProtection
    enableVmProtection: parEnableVmProtection
    encryption: empty(parEncryption) ? null : {
      enabled: parEncryption.enabled
      enforcement: parEncryption.enforcement
    }
    flowTimeoutInMinutes: parFlowTimeoutInMinutes == 3 ? null : parFlowTimeoutInMinutes
    ipAllocations: empty(parIpAllocations) ? null : parIpAllocations
    subnets: parSubnets
    virtualNetworkPeerings: empty(parVirtualNetworkPeerings) ? null : parVirtualNetworkPeerings
  }
}

// ----------
//  OUTPUTS
// ----------
@description('The Id of the Virtual Network')
output outVirtualNetworkId string = resVirtualNetwork.id

@description('The Name of the Virtual Network')
output outVirtualNetworkName string = resVirtualNetwork.name

@description('The Id and Name of the Virtual Network Subnets')
output outVirtualNetworkSubnets object = varVirtualNetworkSubnets
