function Set-GlyGlyphSet {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, Position = 0)]
    [string] $Name
  )

  if (-not $script:GlyGlyphSets.Contains($Name)) {
    throw "Unknown gly glyph set '$Name'. Use Get-GlyGlyphSet to list available glyph sets."
  }

  $script:GlyConfiguration.GlyphSet = $Name
  Get-GlyConfiguration
}
