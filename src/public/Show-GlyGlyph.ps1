function Show-GlyGlyph {
  [CmdletBinding()]
  param(
    [Alias('Name')]
    [string] $GlyphSet = $script:GlyConfiguration.GlyphSet
  )

  $selectedGlyphSet = Get-GlyGlyphSet -Name $GlyphSet
  $rows = @(
    $sample = ConvertTo-GlyPreviewName
    [pscustomobject] [ordered]@{
      PSTypeName = 'gly.GlyphPreview'
      Matcher    = 'Default'
      Glyph      = $selectedGlyphSet.Default
      Preview    = if ([string]::IsNullOrEmpty($selectedGlyphSet.Default)) { $sample } else { "$($selectedGlyphSet.Default) $sample" }
    }

    foreach ($rule in $selectedGlyphSet.Rules) {
      $sample = ConvertTo-GlyPreviewName -Selector $rule.Selector
      [pscustomobject] [ordered]@{
        PSTypeName = 'gly.GlyphPreview'
        Matcher    = ConvertTo-GlyMatcherLabel -Selector $rule.Selector
        Glyph      = $rule.Glyph
        Preview    = if ([string]::IsNullOrEmpty($rule.Glyph)) { $sample } else { "$($rule.Glyph) $sample" }
      }
    }
  )

  return $rows
}
