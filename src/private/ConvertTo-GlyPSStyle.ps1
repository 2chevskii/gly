function ConvertTo-GlyPSStyle {
  param(
    [GlyStyle] $Style
  )

  return ConvertTo-GlyAnsiStyle -Style $Style
}
