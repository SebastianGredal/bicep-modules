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

function Publish-ChangedModule {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory = $false)]
    [string]$fromCommit = $null,

    [Parameter(Mandatory = $false)]
    [string]$toCommit = $null,

    [Parameter(Mandatory = $true)]
    [string]$registryLoginServer,

    [Parameter(Mandatory = $true)]
    [string]$documentationUri
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
      $existingTags = Get-AzContainerRegistryTag -RegistryName $registryName -Repository "$parentFolder/$filename" -ErrorAction Stop
    }
    catch {
      if ($_.Exception.Message -like '*not found*') {
        $existingTags = $null
      }
      else {
        Write-Error $_.Exception.Message
      }
    }
    if ($existingTags) {
      # If the module exists, get the latest version and compare it to the version in the .bicep file
      $latestVersion = ($existingTags).Tags.Name | Sort-Object | Select-Object -Last 1
      if ([System.Version]$latestVersion -ge [System.Version]$version) {
        Write-Error "The version in the $filename.bicep file is $version, and is therefore lower than or equal to the latest version, $latestVersion in the container registry" -ErrorAction Stop
      }
    }

    $modulePath = $parentFolder + '/' + $filename + ':' + $version
    $target = "br:$registryLoginServer/$modulePath"
    # Publish the .bicep file to the ACR with the semver tag
    if ($PSCmdlet.ShouldProcess("$file", "Publish to ACR with tag $version")) {
      try {
        Publish-AzBicepModule -FilePath $file -Target $target -DocumentationUri $documentationUri -ErrorAction Stop
      }
      catch {
        if ($_.Exception.Message) {
          Write-Error $_.Exception.Message
        }
        Write-Information -MessageData "Successfully published $file to $target"
      }
    }
  }
}
Export-ModuleMember -Function Publish-ChangedModule