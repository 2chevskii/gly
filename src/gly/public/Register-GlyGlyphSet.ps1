function Register-GlyGlyphSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object] $GlyphSet
    )

    process {
        Test-GlyGlyphSet -GlyphSet $GlyphSet | Out-Null
        $copy = Copy-GlyObject -InputObject $GlyphSet
        $name = [string] (Get-GlyValue -InputObject $copy -Name 'Name')

        if ($script:GlyGlyphSets.Contains($name) -and (Get-GlyValue -InputObject $script:GlyGlyphSets[$name] -Name 'BuiltIn' -Default $false)) {
            throw "Built-in gly glyph set '$name' cannot be overwritten. Use Copy-GlyGlyphSet with a new name."
        }

        $copy.BuiltIn = $false
        $script:GlyGlyphSets[$name] = $copy
        [pscustomobject] (Copy-GlyObject -InputObject $copy)
    }
}
