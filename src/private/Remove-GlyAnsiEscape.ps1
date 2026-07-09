function Remove-GlyAnsiEscape {
  param(
    [AllowNull()]
    [string] $Text
  )

  if ($null -eq $Text) {
    return ''
  }

  return [regex]::Replace($Text, "`e\[[0-9;]*m", '')
}
