function Resolve-GlyStyleRenderer {
  $validValues = @('Auto', 'PSStyle', 'Ansi', 'PlainText')

  $preference = Get-Variable -Name GlyStyleRenderer -Scope Global -ErrorAction SilentlyContinue
  if ($null -ne $preference -and -not [string]::IsNullOrWhiteSpace([string] $preference.Value)) {
    $candidate = [string] $preference.Value
    if ($candidate -notin $validValues) {
      throw "Invalid GlyStyleRenderer '$candidate'. Valid values: $($validValues -join ', ')."
    }

    $signature = "Global|$candidate"
    if ($script:GlyStyleRendererCacheKey -eq $signature) {
      return $script:GlyStyleRendererCacheValue
    }

    $script:GlyStyleRendererCacheKey = $signature
    $script:GlyStyleRendererCacheValue = $candidate
    return $candidate
  }

  $configured = [string] $script:GlyConfiguration.StyleRenderer
  if ($configured -notin $validValues) {
    throw "Invalid StyleRenderer '$configured'. Valid values: $($validValues -join ', ')."
  }

  $signature = @(
    'Configuration'
    [string] $script:GlyConfiguration.RespectNoColor
    [string] $env:NO_COLOR
    [string] $script:GlyConfiguration.ShowColors
    $configured
    [string] $PSVersionTable.PSVersion
  ) -join '|'

  if ($script:GlyStyleRendererCacheKey -eq $signature) {
    return $script:GlyStyleRendererCacheValue
  }

  if ($script:GlyConfiguration.RespectNoColor -and -not [string]::IsNullOrEmpty($env:NO_COLOR)) {
    $script:GlyStyleRendererCacheKey = $signature
    $script:GlyStyleRendererCacheValue = 'PlainText'
    return 'PlainText'
  }

  if (-not $script:GlyConfiguration.ShowColors) {
    $script:GlyStyleRendererCacheKey = $signature
    $script:GlyStyleRendererCacheValue = 'PlainText'
    return 'PlainText'
  }

  if ($configured -ne 'Auto') {
    $script:GlyStyleRendererCacheKey = $signature
    $script:GlyStyleRendererCacheValue = $configured
    return $configured
  }

  if ($PSVersionTable.PSVersion -ge [version] '7.2' -and $null -ne (Get-Variable -Name PSStyle -Scope Global -ErrorAction SilentlyContinue)) {
    $script:GlyStyleRendererCacheKey = $signature
    $script:GlyStyleRendererCacheValue = 'PSStyle'
    return 'PSStyle'
  }

  if (Test-GlyAnsiOutputSupported) {
    $script:GlyStyleRendererCacheKey = $signature
    $script:GlyStyleRendererCacheValue = 'Ansi'
    return 'Ansi'
  }

  $script:GlyStyleRendererCacheKey = $signature
  $script:GlyStyleRendererCacheValue = 'PlainText'
  return 'PlainText'
}
