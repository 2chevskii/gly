function Disable-Gly {
    [CmdletBinding()]
    param()

    $script:GlyConfiguration.Enabled = $false
    $script:GlyConfiguration.ShowGlyphs = $false
    $script:GlyConfiguration.ShowColors = $false
}
