function Get-GlyFileSystemKind {
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [System.IO.FileSystemInfo] $InputObject
  )

  process {
    $attributes = $InputObject.Attributes
    if (($attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
      if ($InputObject.LinkType -eq 'Junction') {
        return 'Junction'
      }

      return 'Symlink'
    }

    if ($InputObject -is [System.IO.DirectoryInfo]) {
      return 'Directory'
    }

    if ($InputObject -is [System.IO.FileInfo]) {
      return 'File'
    }

    return 'Other'
  }
}
