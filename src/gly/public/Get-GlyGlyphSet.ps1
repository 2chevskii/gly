function Get-GlyGlyphSet {
    [CmdletBinding()]
    param(
        [string] $Name
    )

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return $script:GlyGlyphSets.Values | ForEach-Object { [pscustomobject] (Copy-GlyObject -InputObject $_) }
    }

    if (-not $script:GlyGlyphSets.Contains($Name)) {
        throw "Unknown gly glyph set '$Name'."
    }

    [pscustomobject] (Copy-GlyObject -InputObject $script:GlyGlyphSets[$Name])
}
