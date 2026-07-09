function Format-GlyFileSize {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  if ($InputObject -isnot [System.IO.FileInfo]) {
    return ''
  }

  $length = $InputObject.Length
  if ($script:GlyConfiguration.SizeFormat -eq 'Binary') {
    $units = @('B', 'KiB', 'MiB', 'GiB', 'TiB')
    $value = [double] $length
    $index = 0
    while ($value -ge 1024 -and $index -lt ($units.Count - 1)) {
      $value = $value / 1024
      $index++
    }

    if ($index -eq 0) {
      return "$length B"
    }

    return ('{0:N1} {1}' -f $value, $units[$index])
  }

  return $length
}
