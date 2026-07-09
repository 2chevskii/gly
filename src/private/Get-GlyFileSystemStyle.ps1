function Get-GlyFileSystemStyle {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  if (-not $script:GlyConfiguration.Enabled -or -not $script:GlyConfiguration.ShowColors) {
    return $null
  }

  $theme = $script:GlyThemes[$script:GlyConfiguration.Theme]
  if ($null -eq $theme) {
    return $null
  }

  $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules $theme.Rules
  if ($null -ne $rule) {
    return $rule.Style
  }

  return $theme.Default
}
