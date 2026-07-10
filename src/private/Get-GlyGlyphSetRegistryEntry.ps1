function Get-GlyGlyphSetRegistryEntry {
  param(
    [Parameter(Mandatory)]
    [string] $Name
  )

  $entry = $script:GlyGlyphSets[$Name]
  if ($entry -is [GlyGlyphSet] -or $null -eq $entry) {
    return $entry
  }

  $rules = foreach ($definition in Get-GlyBuiltInSelectorCatalog) {
    if ($entry.Map.ContainsKey($definition.Token)) {
      [GlyGlyphRule]@{
        Selector = $definition.Selector
        Glyph    = [string] $entry.Map[$definition.Token]
      }
    }
  }

  return [GlyGlyphSet]@{
    Name    = $entry.Name
    BuiltIn = $true
    Default = [string] $entry.Map.Default
    Rules   = [GlyGlyphRule[]] @($rules)
  }
}
