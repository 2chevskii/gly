function Get-GlyLinkSuffix {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  if (($InputObject.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -eq 0) {
    return ''
  }

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
