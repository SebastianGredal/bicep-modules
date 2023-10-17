using './virtual-network.bicep'

param parPrefix = 'test-'
param parSuffix = '-01'
param parName = '${parPrefix}vnet${parSuffix}'
param parLocation = 'westeurope'
param parAddressPrefixes = [
  '10.0.0.0/23'
]
param parVirtualNetworkCommunity = ''
param parDdosProtectionPlanId = ''
param parDnsServers = []
param parEnableVmProtection = false
param parEncryption = {}
param parFlowTimeoutInMinutes = -1
param parIpAllocations = []
param parSubnets = [
  {
    name: 'snet-1'
    properties: {
      addressPrefix: '10.0.0.0/24'
    }
  }
]
param parVirtualNetworkPeerings = []
