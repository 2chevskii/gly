function Copy-GlyTheme {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [string] $NewName
    )

    if (-not $script:GlyThemes.Contains($Name)) {
        throw "Unknown gly theme '$Name'."
    }

    $copy = Copy-GlyObject -InputObject $script:GlyThemes[$Name]
    $copy.Name = $NewName
    $copy.BuiltIn = $false
    [pscustomobject] $copy
}
