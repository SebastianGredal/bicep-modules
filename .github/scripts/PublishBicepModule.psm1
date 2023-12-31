function Get-ChangedModule {
  param(
    [Parameter()]
    [string]$fromCommit,

    [Parameter()]
    [string]$toCommit
  )

  # Get the root directory of the git repository
  $rootDir = git rev-parse --show-toplevel

  # Get the list of changed files
  $changedFiles = git diff --name-only $fromCommit $toCommit

  $changedBicepFiles = $changedFiles | Where-Object { $_ -like '*.bicep' }

  # Convert to absolute paths
  $changedBicepFiles = $changedBicepFiles | ForEach-Object { Join-Path $rootDir $_ }

  return $changedBicepFiles
}

<#
.SYNOPSIS
Publishes changed Bicep modules to an Azure Container Registry.

.DESCRIPTION
This function publishes changed Bicep modules to an Azure Container Registry (ACR). It first builds the Bicep file, gets the version from the .json file, and checks if the module already exists in the ACR. If the module exists, it compares the latest version in the ACR to the version in the .bicep file. If the version in the .bicep file is lower than or equal to the latest version in the ACR, it throws an error. If the module does not exist in the ACR, it publishes the .bicep file to the ACR with the semver tag.

.PARAMETER fromCommit
The commit hash or branch name to compare changes from. If not specified, it will compare changes from the last commit.

.PARAMETER toCommit
The commit hash or branch name to compare changes to. If not specified, it will compare changes to the current working directory.

.PARAMETER registryLoginServer
The login server for the Azure Container Registry.

.EXAMPLE
Publish-ChangedModule -registryLoginServer "myregistry.azurecr.io" -Verbose
Publishes all changed Bicep modules to the specified Azure Container Registry.

.NOTES
This function requires the Azure PowerShell module and the Bicep CLI to be installed.
#>
function Publish-ChangedModule {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $false)]
    [string]$fromCommit = $null,

    [Parameter(Mandatory = $false)]
    [string]$toCommit = $null,

    [Parameter(Mandatory = $true)]
    [string]$registryLoginServer
  )
  $changedBicepFiles = Get-ChangedModule -fromCommit $fromCommit -toCommit $toCommit

  foreach ($file in $changedBicepFiles) {
    $filename = ([System.IO.Path]::GetFileNameWithoutExtension($file)).ToLower()
    $parentFolder = (Split-Path $file -Parent | Split-Path -Leaf).ToLower()
    $registryName = $registryLoginServer.Split('.')[0]

    # Build Bicep File
    bicep build $file

    # Get version from json
    $json = Get-Content -Path "modules/$parentFolder/$filename.json" -Raw | ConvertFrom-Json
    $version = $json.metadata.version

    # Check if the module exists in the ACR
    try {
      $existingTags = (Get-AzContainerRegistryTag -RegistryName $registryName -Repository "$parentFolder/$filename").Tags
    }
    catch {
      if ($_.Exception.Message -like '*not found*') {
        $existingTags = $null
      }
      else {
        Write-Error $_.Exception.Message
      }
    }
    $latestVersion = $null
    if ($existingTags) {
      # If the module exists, get the latest version and compare it to the version in the .bicep file
      $latestVersion = ($existingTags | Sort-Object LastUpdateTime | Select-Object -Last 1).Name
      if ([System.Version]$latestVersion -ge [System.Version]$version) {
        Write-Error "MODULE VERSION: The version in the $filename.bicep file is $version, and is therefore lower than or equal to the latest version, $latestVersion in the container registry"
      }
      Write-Information -MessageData "MODULE VERSION: The latest version for file: $filename is $version, and will be set as the latest version replacing the previous version $latestVersion"
    }
    else {
      Write-Information -MessageData "MODULE VERSION: The module $filename does not exist in the container registry, the version $version will be set as the latest version"
    }

    $modulePath = $parentFolder + '/' + $filename + ':' + $version
    $target = "br:$registryLoginServer/$modulePath"
    # Publish the .bicep file to the ACR with the semver tag
    if ($PSCmdlet.ShouldProcess("$file", "Publish to ACR with tag $version")) {
      try {
        Publish-AzBicepModule -FilePath $file -Target $target
      }
      catch {
        if ($_.Exception.Message) {
          Write-Error $_.Exception.Message
        }
        Write-Information -MessageData "PUBLISH: Successfully published $file to $target with version $version"
      }
    }
  }
}
Export-ModuleMember -Function Publish-ChangedModule
