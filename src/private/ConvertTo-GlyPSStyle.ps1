function ConvertTo-GlyPSStyle {
  param(
    [object] $Style
  )

  return ConvertTo-GlyAnsiStyle -Style $Style
}
