function Initialize-GlyConfiguration {
  $script:GlyConfiguration = [GlyConfiguration]@{
    Enabled        = $true
    Theme          = 'DefaultDark'
    GlyphSet       = 'NerdFonts'
    ShowGlyphs     = $true
    ShowColors     = $true
    SizeFormat     = [GlySizeFormat]::Raw
    DateFormat     = [GlyDateFormat]::Default
    StyleRenderer  = [GlyStyleRenderer]::Auto
    RespectNoColor = $true
    ResetAfterName = $true
  }
  $script:GlyAnsiStyleCache = @{}
  $script:GlyStyleRendererCacheKey = $null
  $script:GlyStyleRendererCacheValue = $null
}
