function Register-GlyGlyphSet {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [object] $GlyphSet
  )

  process {
    Test-GlyGlyphSet -GlyphSet $GlyphSet | Out-Null
    $copy = ConvertTo-GlyGlyphSet -GlyphSet $GlyphSet
    $name = $copy.Name

    if ($script:GlyGlyphSets.Contains($name) -and $script:GlyGlyphSets[$name].BuiltIn) {
      throw "Built-in gly glyph set '$name' cannot be overwritten. Use Copy-GlyGlyphSet with a new name."
    }

    $copy.BuiltIn = $false
    $script:GlyGlyphSets[$name] = $copy
    ConvertTo-GlyGlyphSet -GlyphSet $copy
  }
}
