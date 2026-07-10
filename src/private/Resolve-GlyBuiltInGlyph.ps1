function Resolve-GlyBuiltInGlyph {
  param(
    [Parameter(Mandatory)]
    [object] $GlyphSet,

    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject,

    [GlyBuiltInSelectorDefinition] $ResolvedSelector
  )

  if ($null -ne $ResolvedSelector -and $GlyphSet.Map.ContainsKey($ResolvedSelector.Token)) {
    return [string] $GlyphSet.Map[$ResolvedSelector.Token]
  }
  if ($GlyphSet.CompleteCatalog) {
    return [string] $GlyphSet.Map.Default
  }

  if ($null -eq $GlyphSet.RuleCache) {
    $GlyphSet.RuleCache = [GlyGlyphRule[]] @(
      foreach ($definition in Get-GlyBuiltInSelectorCatalog) {
        if ($GlyphSet.Map.ContainsKey($definition.Token)) {
          [GlyGlyphRule]@{
            Selector = $definition.Selector
            Glyph    = [string] $GlyphSet.Map[$definition.Token]
          }
        }
      }
    )
  }

  $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules $GlyphSet.RuleCache
  if ($null -ne $rule) {
    return $rule.Glyph
  }
  return [string] $GlyphSet.Map.Default
}
