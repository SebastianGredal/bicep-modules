# Virtual Network

Module for the Creation of a Virtual Network

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parName        | Yes      | The name of the Virtual Network.
parLocation    | No       | The Azure Region to deploy the resources into.

### parName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the Virtual Network.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

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
        "parName": {
            "value": ""
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        }
    }
}
```
