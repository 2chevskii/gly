function Get-GlyThemeRegistryEntry {
  param(
    [Parameter(Mandatory)]
    [string] $Name
  )

  $entry = $script:GlyThemes[$Name]
  if ($entry -is [GlyTheme] -or $null -eq $entry) {
    return $entry
  }

  $default = Get-GlyBuiltInThemeStyle -Theme $entry -Palette File
  $rules = if ($entry.HasRules) {
    foreach ($definition in Get-GlyBuiltInSelectorCatalog) {
      [GlyThemeRule]@{
        Selector = $definition.Selector
        Style    = Get-GlyBuiltInThemeStyle -Theme $entry -Palette $definition.Palette -Bold $definition.Bold
      }
    }
  }
  else {
    @()
  }

  return [GlyTheme]@{
    Name    = $entry.Name
    BuiltIn = $true
    Default = $default
    Rules   = [GlyThemeRule[]] @($rules)
  }
}
