$dirPath = 'modules'
$bicepFiles = Get-ChildItem -Path $dirPath -Filter '*.bicep' -Recurse

$bicepTemplate = ''

foreach ($file in $bicepFiles) {
  # Generate a Bicep module block with a unique name and module path
  $moduleBlock = @"
module $($file.BaseName.Replace('-','')) '$(($file.FullName | Resolve-Path -Relative).Replace('\','/'))' = {
  name: '$($file.BaseName)'
  params: {
    // Add your parameters here
  }
}

"@

  $bicepTemplate += $moduleBlock
}

$bicepTemplate | Out-File -FilePath 'main.bicep'