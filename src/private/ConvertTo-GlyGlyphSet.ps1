function ConvertTo-GlyGlyphSet {
  param(
    [Parameter(Mandatory)]
    [object] $GlyphSet
  )

  $result = [GlyGlyphSet]::new()
  $result.Name = [string] (Get-GlyValue -InputObject $GlyphSet -Name 'Name')
  $result.BuiltIn = [bool] (Get-GlyValue -InputObject $GlyphSet -Name 'BuiltIn' -Default $false)
  $default = Get-GlyValue -InputObject $GlyphSet -Name 'Default'
  if ($null -ne $default) {
    $result.Default = [string] $default
  }

  $rules = foreach ($rule in @(Get-GlyValue -InputObject $GlyphSet -Name 'Rules' -Default @())) {
    $typedRule = [GlyGlyphRule]::new()
    $typedRule.Selector = ConvertTo-GlySelector -Selector (Get-GlyValue -InputObject $rule -Name 'Selector')
    $typedRule.Glyph = [string] (Get-GlyValue -InputObject $rule -Name 'Glyph')
    $typedRule
  }
  $result.Rules = [GlyGlyphRule[]] @($rules)
  return $result
}
