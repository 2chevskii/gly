function Get-GlyGlyphSet {
  [CmdletBinding()]
  param(
    [string] $Name
  )

  if ([string]::IsNullOrWhiteSpace($Name)) {
    return $script:GlyGlyphSets.Keys | ForEach-Object {
      ConvertTo-GlyGlyphSet -GlyphSet (Get-GlyGlyphSetRegistryEntry -Name $_)
    }
  }

  if (-not $script:GlyGlyphSets.Contains($Name)) {
    throw "Unknown gly glyph set '$Name'."
  }

  ConvertTo-GlyGlyphSet -GlyphSet (Get-GlyGlyphSetRegistryEntry -Name $Name)
}
