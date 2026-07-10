function Resolve-GlyStyleRenderer {
  $preference = [string] $global:GlyStyleRenderer
  $configured = [string] $script:GlyConfiguration.StyleRenderer
  $noColor = [string] $env:NO_COLOR
  $signature = [string]::Concat(
    $preference, '|',
    $configured, '|',
    $noColor, '|',
    [string] $script:GlyConfiguration.RespectNoColor, '|',
    [string] $script:GlyConfiguration.ShowColors
  )

  if ($script:GlyStyleRendererCacheKey -eq $signature) {
    return $script:GlyStyleRendererCacheValue
  }

  $validValues = @('Auto', 'PSStyle', 'Ansi', 'PlainText')
  if (-not [string]::IsNullOrWhiteSpace($preference)) {
    if ($preference -notin $validValues) {
      throw "Invalid GlyStyleRenderer '$preference'. Valid values: $($validValues -join ', ')."
    }
    $renderer = $preference
  }
  elseif ($configured -notin $validValues) {
    throw "Invalid StyleRenderer '$configured'. Valid values: $($validValues -join ', ')."
  }
  elseif ($script:GlyConfiguration.RespectNoColor -and -not [string]::IsNullOrEmpty($noColor)) {
    $renderer = 'PlainText'
  }
  elseif (-not $script:GlyConfiguration.ShowColors) {
    $renderer = 'PlainText'
  }
  elseif ($configured -ne 'Auto') {
    $renderer = $configured
  }
  elseif ($PSVersionTable.PSVersion -ge [version] '7.2' -and $null -ne $global:PSStyle) {
    $renderer = 'PSStyle'
  }
  elseif (Test-GlyAnsiOutputSupported) {
    $renderer = 'Ansi'
  }
  else {
    $renderer = 'PlainText'
  }

  $script:GlyStyleRendererCacheKey = $signature
  $script:GlyStyleRendererCacheValue = $renderer
  return $renderer
}
