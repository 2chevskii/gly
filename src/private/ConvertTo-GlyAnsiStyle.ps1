function ConvertTo-GlyAnsiStyle {
  param(
    [GlyStyle] $Style
  )

  if ($null -eq $Style) {
    return ''
  }

  if ($null -eq $script:GlyAnsiStyleCache) {
    $script:GlyAnsiStyleCache = @{}
  }

  $bold = $Style.Bold
  $italic = $Style.Italic
  $underline = $Style.Underline
  $foreground = $Style.Foreground
  $background = $Style.Background
  $cacheKey = "$bold|$italic|$underline|$foreground|$background"

  if ($script:GlyAnsiStyleCache.ContainsKey($cacheKey)) {
    return $script:GlyAnsiStyleCache[$cacheKey]
  }

  $codes = @()
  if ($bold) { $codes += '1' }
  if ($italic) { $codes += '3' }
  if ($underline) { $codes += '4' }

  foreach ($entry in @(
      @{ Color = $foreground; Prefix = '38' },
      @{ Color = $background; Prefix = '48' }
    )) {
    $color = $entry.Color
    if ($color -match '^#(?<r>[0-9a-fA-F]{2})(?<g>[0-9a-fA-F]{2})(?<b>[0-9a-fA-F]{2})$') {
      $r = [Convert]::ToInt32($Matches.r, 16)
      $g = [Convert]::ToInt32($Matches.g, 16)
      $b = [Convert]::ToInt32($Matches.b, 16)
      $codes += "$($entry.Prefix);2;$r;$g;$b"
    }
  }

  if ($codes.Count -eq 0) {
    $script:GlyAnsiStyleCache[$cacheKey] = ''
    return ''
  }

  $ansiStyle = "$([char]27)[$($codes -join ';')m"
  $script:GlyAnsiStyleCache[$cacheKey] = $ansiStyle
  return $ansiStyle
}
