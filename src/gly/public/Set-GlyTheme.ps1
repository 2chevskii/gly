function Set-GlyTheme {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, Position = 0)]
    [string] $Name
  )

  if (-not $script:GlyThemes.Contains($Name)) {
    throw "Unknown gly theme '$Name'. Use Get-GlyTheme to list available themes."
  }

  $script:GlyConfiguration.Theme = $Name
  Get-GlyConfiguration
}
