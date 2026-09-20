function Resolve-GlyBuiltInThemeStyle {
  param(
    [Parameter(Mandatory)]
    [object] $Theme,

    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  $attributes = $InputObject.Attributes
  if (($attributes -band [System.IO.FileAttributes]::Hidden) -ne 0) {
    return Get-GlyBuiltInThemeStyle -Theme $Theme -Palette Hidden
  }
  if (($attributes -band [System.IO.FileAttributes]::ReadOnly) -ne 0) {
    return Get-GlyBuiltInThemeStyle -Theme $Theme -Palette ReadOnly
  }

  $kind = Get-GlyFileSystemKind -InputObject $InputObject
  if ($kind -eq 'Junction' -or $kind -eq 'Symlink') {
    return Get-GlyBuiltInThemeStyle -Theme $Theme -Palette Symlink
  }
  if ($kind -eq 'Directory') {
    return Get-GlyBuiltInThemeStyle -Theme $Theme -Palette Directory -Bold $true
  }

  return Get-GlyBuiltInThemeStyle -Theme $Theme -Palette File
}
