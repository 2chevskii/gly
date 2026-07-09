function Get-GlyFileSystemStyle {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo] $InputObject
    )

    if (-not $script:GlyConfiguration.Enabled -or -not $script:GlyConfiguration.ShowColors) {
        return $null
    }

    $theme = $script:GlyThemes[$script:GlyConfiguration.Theme]
    if ($null -eq $theme) {
        return $null
    }

    $rule = Resolve-GlyFileSystemRule -InputObject $InputObject -Rules (Get-GlyValue -InputObject $theme -Name 'Rules' -Default @())
    if ($null -ne $rule) {
        return Get-GlyValue -InputObject $rule -Name 'Style'
    }

    return Get-GlyValue -InputObject $theme -Name 'Default'
}
