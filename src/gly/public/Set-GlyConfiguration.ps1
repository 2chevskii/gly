function Set-GlyConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string] $Theme,
        [string] $GlyphSet,
        [bool] $Enabled,
        [bool] $ShowGlyphs,
        [bool] $ShowColors,
        [ValidateSet('Raw', 'Binary')]
        [string] $SizeFormat,
        [ValidateSet('Default', 'Iso')]
        [string] $DateFormat,
        [ValidateSet('Auto', 'PSStyle', 'Ansi', 'PlainText')]
        [string] $StyleRenderer,
        [bool] $RespectNoColor,
        [bool] $ResetAfterName
    )

    if ($PSBoundParameters.ContainsKey('Theme') -and -not $script:GlyThemes.Contains($Theme)) {
        throw "Unknown gly theme '$Theme'. Use Get-GlyTheme to list available themes."
    }

    if ($PSBoundParameters.ContainsKey('GlyphSet') -and -not $script:GlyGlyphSets.Contains($GlyphSet)) {
        throw "Unknown gly glyph set '$GlyphSet'. Use Get-GlyGlyphSet to list available glyph sets."
    }

    foreach ($key in $PSBoundParameters.Keys) {
        if ($key -eq 'WhatIf' -or $key -eq 'Confirm') {
            continue
        }

        if ($PSCmdlet.ShouldProcess('gly session configuration', "Set $key")) {
            $script:GlyConfiguration[$key] = $PSBoundParameters[$key]
        }
    }

    Get-GlyConfiguration
}
