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

  $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules (Get-GlyValue -InputObject $glyphSet -Name 'Rules' -Default @())
  if ($null -ne $rule) {
    return [string] (Get-GlyValue -InputObject $rule -Name 'Glyph' -Default '')
  }

  return [string] (Get-GlyValue -InputObject $glyphSet -Name 'Default' -Default '')
}
