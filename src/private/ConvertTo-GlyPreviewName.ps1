function ConvertTo-GlyPreviewName {
  param(
    [GlySelector] $Selector
  )

  if ($null -eq $Selector) {
    return 'file.txt'
  }

  $name = if (-not [string]::IsNullOrWhiteSpace($Selector.Name)) {
    $Selector.Name
  }
  elseif ($Selector.Glob.Count -gt 0) {
    $Selector.Glob[0] -replace '\*', 'sample' -replace '\?', 'x'
  }
  elseif ($Selector.Extension.Count -gt 0) {
    $extension = $Selector.Extension[0]
    if ($extension.StartsWith('.')) { "file$extension" } else { "file.$extension" }
  }
  elseif ($Selector.Attributes -contains [System.IO.FileAttributes]::Hidden) {
    '.hidden'
  }
  elseif ($Selector.Attributes -contains [System.IO.FileAttributes]::ReadOnly) {
    'readonly.txt'
  }
  else {
    switch ($Selector.Kind) {
      ([GlyFileSystemKind]::Directory) { 'directory' }
      ([GlyFileSystemKind]::Junction) { 'junction' }
      ([GlyFileSystemKind]::Symlink) { 'link' }
      ([GlyFileSystemKind]::Other) { 'item' }
      default { 'file.txt' }
    }
  }

  switch ($Selector.Kind) {
    ([GlyFileSystemKind]::Directory) { return "$name/" }
    ([GlyFileSystemKind]::Junction) { return "$name -> target/" }
    ([GlyFileSystemKind]::Symlink) { return "$name -> target" }
    default { return $name }
  }
}
