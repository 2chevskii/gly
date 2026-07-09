function Copy-GlyGlyphSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [string] $NewName
    )

    if (-not $script:GlyGlyphSets.Contains($Name)) {
        throw "Unknown gly glyph set '$Name'."
    }

    $copy = Copy-GlyObject -InputObject $script:GlyGlyphSets[$Name]
    $copy.Name = $NewName
    $copy.BuiltIn = $false
    [pscustomobject] $copy
}
