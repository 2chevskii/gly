enum GlyFileSystemKind {
  File
  Directory
  Symlink
  Junction
  Other
}

enum GlySizeFormat {
  Raw
  Binary
}

enum GlyDateFormat {
  Default
  Iso
}

enum GlyStyleRenderer {
  Auto
  PSStyle
  Ansi
  PlainText
}

class GlySelector {
  [System.Nullable[GlyFileSystemKind]] $Kind
  [string] $Name
  [string[]] $Extension = @()
  [string[]] $Glob = @()
  [System.IO.FileAttributes[]] $Attributes = @()
}

class GlyStyle {
  [string] $Foreground
  [string] $Background
  [bool] $Bold
  [bool] $Italic
  [bool] $Underline
}

class GlyThemeRule {
  [GlySelector] $Selector
  [GlyStyle] $Style
}

class GlyGlyphRule {
  [GlySelector] $Selector
  [string] $Glyph
}

class GlyBuiltInSelectorDefinition {
  [string] $Token
  [string] $Palette
  [bool] $Bold
  [GlySelector] $Selector
}

class GlyTheme {
  [string] $Name
  [bool] $BuiltIn
  [GlyStyle] $Default
  [GlyThemeRule[]] $Rules = @()
}

class GlyGlyphSet {
  [string] $Name
  [bool] $BuiltIn
  [string] $Default
  [GlyGlyphRule[]] $Rules = @()
}

class GlyConfiguration {
  [bool] $Enabled
  [string] $Theme
  [string] $GlyphSet
  [bool] $ShowGlyphs
  [bool] $ShowColors
  [GlySizeFormat] $SizeFormat
  [GlyDateFormat] $DateFormat
  [GlyStyleRenderer] $StyleRenderer
  [bool] $RespectNoColor
  [bool] $ResetAfterName
}
