function ConvertTo-GlyAnsiStyle {
  param(
    [object] $Style
  )

  if ($null -eq $Style) {
    return ''
  }

  $codes = @()
  if (Get-GlyValue -InputObject $Style -Name 'Bold' -Default $false) { $codes += '1' }
  if (Get-GlyValue -InputObject $Style -Name 'Italic' -Default $false) { $codes += '3' }
  if (Get-GlyValue -InputObject $Style -Name 'Underline' -Default $false) { $codes += '4' }

  foreach ($entry in @(
      @{ Name = 'Foreground'; Prefix = '38' },
      @{ Name = 'Background'; Prefix = '48' }
    )) {
    $color = [string] (Get-GlyValue -InputObject $Style -Name $entry.Name)
    if ($color -match '^#(?<r>[0-9a-fA-F]{2})(?<g>[0-9a-fA-F]{2})(?<b>[0-9a-fA-F]{2})$') {
      $r = [Convert]::ToInt32($Matches.r, 16)
      $g = [Convert]::ToInt32($Matches.g, 16)
      $b = [Convert]::ToInt32($Matches.b, 16)
      $codes += "$($entry.Prefix);2;$r;$g;$b"
    }
  }

  if ($codes.Count -eq 0) {
    return ''
  }

  return "$([char]27)[$($codes -join ';')m"
}
