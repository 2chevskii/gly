function Get-GlyTheme {
  [CmdletBinding()]
  param(
    [string] $Name
  )

  if ([string]::IsNullOrWhiteSpace($Name)) {
    return $script:GlyThemes.Values | ForEach-Object { ConvertTo-GlyTheme -Theme $_ }
  }

  if (-not $script:GlyThemes.Contains($Name)) {
    throw "Unknown gly theme '$Name'."
  }

  ConvertTo-GlyTheme -Theme $script:GlyThemes[$Name]
}
