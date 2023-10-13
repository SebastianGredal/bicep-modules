//
// Baseline resource sample
//
targetScope = 'resourceGroup'

metadata name = 'Virtual Network'
metadata description = 'Module for the Creation of a Virtual Network'
metadata version = '1.0.11'
// ----------
// PARAMETERS
// ----------
@description('The name of the Virtual Network.')
param parName string

@description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

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
      addressPrefixes: [
        '10.0.0.0/8'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

// ----------
//  OUTPUTS
// ----------
