function Get-GlyFileSystemItem {
  param(
    [string[]] $Path,
    [string[]] $LiteralPath,
    [System.IO.FileSystemInfo[]] $InputObject
  )

  $items = @()
  if ($InputObject) {
    $items += $InputObject
  }

  if ($Path) {
    foreach ($itemPath in $Path) {
      $items += Get-ChildItem -Path $itemPath
    }
  }

  if ($LiteralPath) {
    foreach ($itemPath in $LiteralPath) {
      $items += Get-ChildItem -LiteralPath $itemPath
    }
  }

  if (-not $InputObject -and -not $Path -and -not $LiteralPath) {
    $items += Get-ChildItem
  }

  return $items
}
