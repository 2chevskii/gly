function Test-GlyTheme {
  param(
    [Parameter(Mandatory)]
    [object] $Theme
  )

  $name = Get-GlyValue -InputObject $Theme -Name 'Name'
  if ([string]::IsNullOrWhiteSpace([string] $name)) {
    throw 'Theme must define a non-empty Name.'
  }

  $rules = Get-GlyValue -InputObject $Theme -Name 'Rules' -Default @()
  foreach ($rule in @($rules)) {
    if ($null -eq (Get-GlyValue -InputObject $rule -Name 'Selector')) {
      throw "Theme '$name' contains a rule without Selector."
    }
    if ($null -eq (Get-GlyValue -InputObject $rule -Name 'Style')) {
      throw "Theme '$name' contains a rule without Style."
    }
  }

  return $true
}
