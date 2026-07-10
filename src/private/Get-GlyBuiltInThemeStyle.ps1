function Get-GlyBuiltInThemeStyle {
  param(
    [Parameter(Mandatory)]
    [object] $Theme,

    [Parameter(Mandatory)]
    [string] $Palette,

    [bool] $Bold = $false
  )

  $cacheKey = "$Palette|$Bold"
  if ($Theme.StyleCache.ContainsKey($cacheKey)) {
    return $Theme.StyleCache[$cacheKey]
  }

  $style = [GlyStyle]@{
    Foreground = [string] $Theme.Palette[$Palette]
    Background = $null
    Bold       = $Bold
    Italic     = $false
    Underline  = $false
  }
  $Theme.StyleCache[$cacheKey] = $style
  return $style
}
