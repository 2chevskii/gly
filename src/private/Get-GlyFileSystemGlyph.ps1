function Get-GlyFileSystemGlyph {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  if (-not $script:GlyConfiguration.Enabled -or -not $script:GlyConfiguration.ShowGlyphs) {
    return ''
  }

  $glyphSet = $script:GlyGlyphSets[$script:GlyConfiguration.GlyphSet]
  if ($null -eq $glyphSet) {
    return ''
  }

  if ($glyphSet -isnot [GlyGlyphSet]) {
    $definition = if ($glyphSet.CompleteCatalog) {
      Resolve-GlyBuiltInSelector -InputObject $InputObject
    }
    else {
      $null
    }
    return Resolve-GlyBuiltInGlyph -GlyphSet $glyphSet -InputObject $InputObject -ResolvedSelector $definition
  }

  $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules $glyphSet.Rules
  if ($null -ne $rule) {
    return $rule.Glyph
  }

  return $glyphSet.Default
}
