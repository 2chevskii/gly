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
    $sample = ConvertTo-GlyPreviewName
    [pscustomobject] [ordered]@{
      PSTypeName = 'gly.GlyphPreview'
      GlyphSet   = $selectedGlyphSet.Name
      Matcher    = 'Default'
      Glyph      = $selectedGlyphSet.Default
      Preview    = if ([string]::IsNullOrEmpty($selectedGlyphSet.Default)) { $sample } else { "$($selectedGlyphSet.Default) $sample" }
    }

    foreach ($rule in $selectedGlyphSet.Rules) {
      $sample = ConvertTo-GlyPreviewName -Selector $rule.Selector
      [pscustomobject] [ordered]@{
        PSTypeName = 'gly.GlyphPreview'
        GlyphSet   = $selectedGlyphSet.Name
        Matcher    = ConvertTo-GlyMatcherLabel -Selector $rule.Selector
        Glyph      = $rule.Glyph
        Preview    = if ([string]::IsNullOrEmpty($rule.Glyph)) { $sample } else { "$($rule.Glyph) $sample" }
      }
    }
  }

  return $rows
}
