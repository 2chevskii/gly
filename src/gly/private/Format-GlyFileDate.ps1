function Format-GlyFileDate {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo] $InputObject
    )

    if ($script:GlyConfiguration.DateFormat -eq 'Iso') {
        return $InputObject.LastWriteTime.ToString('yyyy-MM-dd HH:mm')
    }

    return $InputObject.LastWriteTime
}
