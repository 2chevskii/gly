function Enable-Gly {
  [CmdletBinding()]
  param()

  $script:GlyConfiguration.Enabled = $true
  if (-not $script:GlyFormatDataLoaded -and (Test-Path -LiteralPath $script:GlyFormatDataPath)) {
    Update-FormatData -PrependPath $script:GlyFormatDataPath -ErrorAction Stop
    $script:GlyFormatDataLoaded = $true
  }
}
