function ConvertTo-GlyStyle {
  param(
    [AllowNull()]
    [object] $Style
  )

  if ($null -eq $Style) {
    return $null
  }

  $result = [GlyStyle]::new()
  foreach ($name in @('Foreground', 'Background')) {
    $value = Get-GlyValue -InputObject $Style -Name $name
    if (-not [string]::IsNullOrEmpty([string] $value)) {
      $color = [string] $value
      if ($color -notmatch '^#[0-9a-fA-F]{6}$') {
        throw "Invalid $name color '$color'. Use #RRGGBB or `$null."
      }
      $result.$name = $color
    }
  }

  foreach ($name in @('Bold', 'Italic', 'Underline')) {
    $result.$name = [bool] (Get-GlyValue -InputObject $Style -Name $name -Default $false)
  }

  return $result
}
