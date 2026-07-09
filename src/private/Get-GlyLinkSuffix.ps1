function Get-GlyLinkSuffix {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  $target = $InputObject.Target
  if ($null -eq $target) {
    return ''
  }

  $items = @($target) | Where-Object { -not [string]::IsNullOrWhiteSpace([string] $_) }
  if ($items.Count -eq 0) {
    return ''
  }

  return " -> $($items -join ', ')"
}
