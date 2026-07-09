function Initialize-GlyConfiguration {
    $script:GlyConfiguration = [ordered]@{
        Enabled = $true
        Theme = 'DefaultDark'
        GlyphSet = 'NerdFonts'
        ShowGlyphs = $true
        ShowColors = $true
        SizeFormat = 'Raw'
        DateFormat = 'Default'
        StyleRenderer = 'Auto'
        RespectNoColor = $true
        ResetAfterName = $true
    }
}
