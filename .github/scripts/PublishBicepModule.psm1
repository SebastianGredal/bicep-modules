function Get-ChangedModule {
  param(
    [Parameter()]
    [string]$fromCommit,

    [Parameter()]
    [string]$toBranch = 'main'
  )

  # Get the root directory of the git repository
  $rootDir = git rev-parse --show-toplevel

  # Get the list of changed files
  $changedFiles = git diff --name-only $fromCommit $toBranch

  # Filter the list to only include .bicep files
  $changedBicepFiles = $changedFiles | Where-Object { $_ -like '*.bicep' }

  # Convert to absolute paths
  $changedBicepFiles = $changedBicepFiles | ForEach-Object { Join-Path $rootDir $_ }

  return $changedBicepFiles
}

function Publish-ChangedModule {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $false)]
    [string]$fromCommit = $null,

    [Parameter(Mandatory = $false)]
    [string]$toBranch = 'main',

    [Parameter(Mandatory = $true)]
    [string]$registryName,

    [Parameter(Mandatory = $true)]
    [string]$documentationUri
  )

  # Get the changed .bicep files
  $changedBicepFiles = Get-ChangedModule -fromCommit $fromCommit -toBranch $toBranch

  foreach ($file in $changedBicepFiles) {
    # Get the filename without extension
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($file)

    # Get the parent folder name
    $parentFolder = Split-Path $file -Parent | Split-Path -Leaf

    # Check if the module exists in the ACR
    $existingTags = az acr repository show-tags --name $registryName --repository "$parentFolder/$filename" --output tsv 2>$null

    if ($existingTags) {
      # If the module exists, get the latest version and increment the patch number
      $latestVersion = $existingTags | Sort-Object | Select-Object -Last 1
      $versionParts = $latestVersion.Split('.')
      $versionParts[2] = [int]$versionParts[2] + 1
      $newVersion = $versionParts -join '.'
    }
    else {
      # If the module doesn't exist, start with version 1.0.0
      $newVersion = '1.0.0'
    }

    $modulePath = $parentFolder + '/' + $filename + ':' + $newVersion
    $target = ("br:$registryName/$modulePath").ToLower()
    # Publish the .bicep file to the ACR with the semver tag
    if ($PSCmdlet.ShouldProcess("$file", "Publish to ACR with tag v$newVersion")) {
      az bicep publish --file $file --target $target --documentationUri $documentationUri
    }
  }
}
Export-ModuleMember -Function Publish-ChangedModule
#Publish-ChangedBicepFiles -registryName 'sbgbicep.azurecr.io' -toBranch main -documentationUri 'https://github.com/SebastianGredal/bicep-modules'