function Show-GlyGlyph {
  [CmdletBinding(DefaultParameterSetName = 'Selected')]
  param(
    [Parameter(ParameterSetName = 'Selected', Position = 0)]
    [Alias('Name')]
    [string] $GlyphSet = $script:GlyConfiguration.GlyphSet,

    [Parameter(Mandatory, ParameterSetName = 'All')]
    [switch] $All
  )

  $selectedGlyphSets = if ($All) {
    @(Get-GlyGlyphSet)
  }
  else {
    @(Get-GlyGlyphSet -Name $GlyphSet)
  }

  $rows = foreach ($selectedGlyphSet in $selectedGlyphSets) {
    [pscustomobject] [ordered]@{
      PSTypeName = 'gly.GlyphPreview'
      GlyphSet   = $selectedGlyphSet.Name
      Matcher    = 'Default'
      Glyph      = $selectedGlyphSet.Default
    }

    foreach ($rule in $selectedGlyphSet.Rules) {
      [pscustomobject] [ordered]@{
        PSTypeName = 'gly.GlyphPreview'
        GlyphSet   = $selectedGlyphSet.Name
        Matcher    = ConvertTo-GlyMatcherLabel -Selector $rule.Selector
        Glyph      = $rule.Glyph
      }
    }
  }

  return $rows
}
