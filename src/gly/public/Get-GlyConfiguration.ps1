function Get-GlyConfiguration {
    [CmdletBinding()]
    param()

    [pscustomobject] (Copy-GlyObject -InputObject $script:GlyConfiguration)
}
