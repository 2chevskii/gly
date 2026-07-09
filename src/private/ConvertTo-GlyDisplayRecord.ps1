function ConvertTo-GlyDisplayRecord {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  [pscustomobject]@{
    Mode          = $InputObject.Mode
    LastWriteTime = Format-GlyFileDate -InputObject $InputObject
    Length        = Format-GlyFileSize -InputObject $InputObject
    Name          = Get-GlyFileSystemDisplayName -InputObject $InputObject
  }
}
