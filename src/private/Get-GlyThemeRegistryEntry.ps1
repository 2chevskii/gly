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
  $essentialTokens = @('dir', 'junction', 'lnk', 'readonly', 'hidden')
  $rules = if ($entry.HasRules) {
    foreach ($definition in Get-GlyBuiltInSelectorCatalog) {
      if ($definition.Token -in $essentialTokens) {
        [GlyThemeRule]@{
          Selector = $definition.Selector
          Style    = Get-GlyBuiltInThemeStyle -Theme $entry -Palette $definition.Palette -Bold $definition.Bold
        }
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
