function Resolve-GlyBuiltInThemeStyle {
  param(
    [Parameter(Mandatory)]
    [object] $Theme,

    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject,

    [GlyBuiltInSelectorDefinition] $ResolvedSelector
  )

  $essentialTokens = @('dir', 'junction', 'lnk', 'readonly', 'hidden')
  if ($null -ne $ResolvedSelector -and $ResolvedSelector.Token -in $essentialTokens) {
    return Get-GlyBuiltInThemeStyle `
      -Theme $Theme `
      -Palette $ResolvedSelector.Palette `
      -Bold $ResolvedSelector.Bold
  }

  if ($null -eq $Theme.RuleCache) {
    $Theme.RuleCache = [GlyThemeRule[]] @(
      foreach ($definition in Get-GlyBuiltInSelectorCatalog) {
        if ($definition.Token -in $essentialTokens) {
          [GlyThemeRule]@{
            Selector = $definition.Selector
            Style    = Get-GlyBuiltInThemeStyle `
              -Theme $Theme `
              -Palette $definition.Palette `
              -Bold $definition.Bold
          }
        }
      }
    )
  }

  $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules $Theme.RuleCache
  if ($null -ne $rule) {
    return $rule.Style
  }
  return Get-GlyBuiltInThemeStyle -Theme $Theme -Palette File
}
