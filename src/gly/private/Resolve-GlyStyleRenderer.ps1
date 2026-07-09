function Resolve-GlyStyleRenderer {
  $validValues = @('Auto', 'PSStyle', 'Ansi', 'PlainText')

  $preference = Get-Variable -Name GlyStyleRenderer -Scope Global -ErrorAction SilentlyContinue
  if ($null -ne $preference -and -not [string]::IsNullOrWhiteSpace([string] $preference.Value)) {
    $candidate = [string] $preference.Value
    if ($candidate -notin $validValues) {
      throw "Invalid GlyStyleRenderer '$candidate'. Valid values: $($validValues -join ', ')."
    }
    return $candidate
  }

  if ($script:GlyConfiguration.RespectNoColor -and -not [string]::IsNullOrEmpty($env:NO_COLOR)) {
    return 'PlainText'
  }

  if (-not $script:GlyConfiguration.ShowColors) {
    return 'PlainText'
  }

  $configured = [string] $script:GlyConfiguration.StyleRenderer
  if ($configured -notin $validValues) {
    throw "Invalid StyleRenderer '$configured'. Valid values: $($validValues -join ', ')."
  }

  if ($configured -ne 'Auto') {
    return $configured
  }

  if ($PSVersionTable.PSVersion -ge [version] '7.2' -and $null -ne (Get-Variable -Name PSStyle -Scope Global -ErrorAction SilentlyContinue)) {
    return 'PSStyle'
  }

  if (Test-GlyAnsiOutputSupported) {
    return 'Ansi'
  }

  return 'PlainText'
}
