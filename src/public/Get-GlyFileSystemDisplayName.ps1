function Get-GlyFileSystemDisplayName {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [System.IO.FileSystemInfo] $InputObject
  )

  process {
    try {
      $name = $InputObject.Name
      if (($InputObject.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        $name += Get-GlyLinkSuffix -InputObject $InputObject
      }
      if (-not $script:GlyConfiguration.Enabled) {
        return $name
      }

      $glyphSet = if ($script:GlyConfiguration.ShowGlyphs) {
        $script:GlyGlyphSets[$script:GlyConfiguration.GlyphSet]
      }
      else {
        $null
      }
      $theme = if ($script:GlyConfiguration.ShowColors) {
        $script:GlyThemes[$script:GlyConfiguration.Theme]
      }
      else {
        $null
      }

      $builtInSelector = if ($null -ne $glyphSet -and $glyphSet -isnot [GlyGlyphSet] -and $glyphSet.CompleteCatalog) {
        Resolve-GlyBuiltInSelector -InputObject $InputObject
      }
      else {
        $null
      }

      $glyph = if ($null -eq $glyphSet) {
        ''
      }
      elseif ($glyphSet -isnot [GlyGlyphSet]) {
        Resolve-GlyBuiltInGlyph -GlyphSet $glyphSet -InputObject $InputObject -ResolvedSelector $builtInSelector
      }
      else {
        $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules $glyphSet.Rules
        if ($null -ne $rule) { $rule.Glyph } else { $glyphSet.Default }
      }
      $displayName = if ([string]::IsNullOrEmpty($glyph)) { $name } else { "$glyph $name" }

      $renderer = Resolve-GlyStyleRenderer
      if ($renderer -eq 'PlainText') {
        return $displayName
      }

      $style = if ($null -eq $theme) {
        $null
      }
      elseif ($theme -isnot [GlyTheme]) {
        Resolve-GlyBuiltInThemeStyle `
          -Theme $theme `
          -InputObject $InputObject
      }
      else {
        $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules $theme.Rules
        if ($null -ne $rule) { $rule.Style } else { $theme.Default }
      }
      $prefix = if ($renderer -eq 'PSStyle') {
        ConvertTo-GlyPSStyle -Style $style
      }
      else {
        ConvertTo-GlyAnsiStyle -Style $style
      }

      if ([string]::IsNullOrEmpty($prefix)) {
        return $displayName
      }

      $reset = if ($script:GlyConfiguration.ResetAfterName) { "$([char]27)[0m" } else { '' }
      return "$prefix$displayName$reset"
    }
    catch {
      return $InputObject.Name
    }
  }
}
