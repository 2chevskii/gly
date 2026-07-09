function Get-GlyGlyphSet {
  [CmdletBinding()]
  param(
    [string] $Name
  )

  if ([string]::IsNullOrWhiteSpace($Name)) {
    return $script:GlyGlyphSets.Values | ForEach-Object { ConvertTo-GlyGlyphSet -GlyphSet $_ }
  }

  if (-not $script:GlyGlyphSets.Contains($Name)) {
    throw "Unknown gly glyph set '$Name'."
  }

  ConvertTo-GlyGlyphSet -GlyphSet $script:GlyGlyphSets[$Name]
}
