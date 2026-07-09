function Get-GlyTheme {
    [CmdletBinding()]
    param(
        [string] $Name
    )

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return $script:GlyThemes.Values | ForEach-Object { [pscustomobject] (Copy-GlyObject -InputObject $_) }
    }

    if (-not $script:GlyThemes.Contains($Name)) {
        throw "Unknown gly theme '$Name'."
    }

    [pscustomobject] (Copy-GlyObject -InputObject $script:GlyThemes[$Name])
}
