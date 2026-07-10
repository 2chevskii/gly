function Show-GlyThemePreview {
  [CmdletBinding()]
  param(
    [string] $Theme = $script:GlyConfiguration.Theme,

    [string] $GlyphSet = $script:GlyConfiguration.GlyphSet
  )

  $selectedTheme = Get-GlyTheme -Name $Theme
  $selectedGlyphSet = Get-GlyGlyphSet -Name $GlyphSet
  $matchers = [ordered]@{ Default = $null }
  $styles = @{ Default = $selectedTheme.Default }
  $glyphs = @{ Default = $selectedGlyphSet.Default }

  foreach ($rule in $selectedTheme.Rules) {
    $signature = ConvertTo-GlySelectorSignature -Selector $rule.Selector
    if (-not $matchers.Contains($signature)) { $matchers[$signature] = $rule.Selector }
    $styles[$signature] = $rule.Style
  }
  foreach ($rule in $selectedGlyphSet.Rules) {
    $signature = ConvertTo-GlySelectorSignature -Selector $rule.Selector
    if (-not $matchers.Contains($signature)) { $matchers[$signature] = $rule.Selector }
    $glyphs[$signature] = $rule.Glyph
  }

  foreach ($signature in $matchers.Keys) {
    $style = if ($styles.ContainsKey($signature)) { $styles[$signature] } else { $selectedTheme.Default }
    $glyph = if ($glyphs.ContainsKey($signature)) { [string] $glyphs[$signature] } else { $selectedGlyphSet.Default }
    $sample = if ([string]::IsNullOrEmpty($glyph)) { 'Sample' } else { "$glyph Sample" }

    [pscustomobject] [ordered]@{
      PSTypeName = 'gly.ThemePreview'
      Matcher    = ConvertTo-GlyMatcherLabel -Selector $matchers[$signature]
      Glyph      = $glyph
      Color      = ConvertTo-GlyStyleLabel -Style $style
      Preview    = ConvertTo-GlyPreviewText -Text $sample -Style $style
    }
  }
}
