function ConvertTo-GlyTheme {
  param(
    [Parameter(Mandatory)]
    [object] $Theme
  )

  $result = [GlyTheme]::new()
  $result.Name = [string] (Get-GlyValue -InputObject $Theme -Name 'Name')
  $result.BuiltIn = [bool] (Get-GlyValue -InputObject $Theme -Name 'BuiltIn' -Default $false)
  $result.Default = ConvertTo-GlyStyle -Style (Get-GlyValue -InputObject $Theme -Name 'Default')

  $rules = foreach ($rule in @(Get-GlyValue -InputObject $Theme -Name 'Rules' -Default @())) {
    $typedRule = [GlyThemeRule]::new()
    $typedRule.Selector = ConvertTo-GlySelector -Selector (Get-GlyValue -InputObject $rule -Name 'Selector')
    $typedRule.Style = ConvertTo-GlyStyle -Style (Get-GlyValue -InputObject $rule -Name 'Style')
    $typedRule
  }
  $result.Rules = [GlyThemeRule[]] @($rules)
  return $result
}
