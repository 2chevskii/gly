function Test-GlyGlyphSet {
  param(
    [Parameter(Mandatory)]
    [object] $GlyphSet
  )

  $name = Get-GlyValue -InputObject $GlyphSet -Name 'Name'
  if ([string]::IsNullOrWhiteSpace([string] $name)) {
    throw 'Glyph set must define a non-empty Name.'
  }

  $rules = Get-GlyValue -InputObject $GlyphSet -Name 'Rules' -Default @()
  foreach ($rule in @($rules)) {
    if ($null -eq (Get-GlyValue -InputObject $rule -Name 'Selector')) {
      throw "Glyph set '$name' contains a rule without Selector."
    }
    if ($null -eq (Get-GlyValue -InputObject $rule -Name 'Glyph')) {
      throw "Glyph set '$name' contains a rule without Glyph."
    }
  }

  return $true
}
