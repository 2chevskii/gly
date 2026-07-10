function Get-GlyTheme {
  [CmdletBinding()]
  param(
    [string] $Name
  )

  if ([string]::IsNullOrWhiteSpace($Name)) {
    return $script:GlyThemes.Keys | ForEach-Object {
      ConvertTo-GlyTheme -Theme (Get-GlyThemeRegistryEntry -Name $_)
    }
  }

  if (-not $script:GlyThemes.Contains($Name)) {
    throw "Unknown gly theme '$Name'."
  }

  ConvertTo-GlyTheme -Theme (Get-GlyThemeRegistryEntry -Name $Name)
}
