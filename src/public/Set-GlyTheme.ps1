function Set-GlyTheme {
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [Parameter(Mandatory, Position = 0)]
    [string] $Name
  )

  if (-not $script:GlyThemes.Contains($Name)) {
    throw "Unknown gly theme '$Name'. Use Get-GlyTheme to list available themes."
  }

  if ($PSCmdlet.ShouldProcess($Name, 'Set active gly theme')) {
    $script:GlyConfiguration.Theme = $Name
  }

  Get-GlyConfiguration
}
