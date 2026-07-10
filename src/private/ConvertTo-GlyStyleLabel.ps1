function ConvertTo-GlyStyleLabel {
  param(
    [GlyStyle] $Style
  )

  if ($null -eq $Style) {
    return 'None'
  }

  $parts = @()
  if (-not [string]::IsNullOrEmpty($Style.Foreground)) { $parts += "FG $($Style.Foreground)" }
  if (-not [string]::IsNullOrEmpty($Style.Background)) { $parts += "BG $($Style.Background)" }
  if ($Style.Bold) { $parts += 'Bold' }
  if ($Style.Italic) { $parts += 'Italic' }
  if ($Style.Underline) { $parts += 'Underline' }
  if ($parts.Count -eq 0) { return 'None' }
  return $parts -join ', '
}
