function Show-GlyGlyph {
  [CmdletBinding()]
  param(
    [Alias('Name')]
    [string] $GlyphSet = $script:GlyConfiguration.GlyphSet
  )

  $selectedGlyphSet = Get-GlyGlyphSet -Name $GlyphSet
  $rows = @(
    [pscustomobject] [ordered]@{
      PSTypeName = 'gly.GlyphPreview'
      Matcher    = 'Default'
      Glyph      = $selectedGlyphSet.Default
    }

    foreach ($rule in $selectedGlyphSet.Rules) {
      [pscustomobject] [ordered]@{
        PSTypeName = 'gly.GlyphPreview'
        Matcher    = ConvertTo-GlyMatcherLabel -Selector $rule.Selector
        Glyph      = $rule.Glyph
      }
    }
  )

  return $rows
}
