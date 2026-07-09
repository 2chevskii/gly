function Get-GlyConfiguration {
  [CmdletBinding()]
  param()

  [GlyConfiguration]@{
    Enabled        = $script:GlyConfiguration.Enabled
    Theme          = $script:GlyConfiguration.Theme
    GlyphSet       = $script:GlyConfiguration.GlyphSet
    ShowGlyphs     = $script:GlyConfiguration.ShowGlyphs
    ShowColors     = $script:GlyConfiguration.ShowColors
    SizeFormat     = $script:GlyConfiguration.SizeFormat
    DateFormat     = $script:GlyConfiguration.DateFormat
    StyleRenderer  = $script:GlyConfiguration.StyleRenderer
    RespectNoColor = $script:GlyConfiguration.RespectNoColor
    ResetAfterName = $script:GlyConfiguration.ResetAfterName
  }
}
