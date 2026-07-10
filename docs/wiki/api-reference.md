# API Reference

## Module Commands

### Enable-Gly

Enables `gly` configuration and loads format data if needed.

```powershell
Enable-Gly
```

### Disable-Gly

Disables glyphs and colors through configuration.

```powershell
Disable-Gly
```

PowerShell format data remains loaded in the current session.

### Get-GlyConfiguration

Returns a detached `GlyConfiguration` copy of the current session configuration.

```powershell
Get-GlyConfiguration
```

### Set-GlyConfiguration

Updates selected configuration values.

```powershell
Set-GlyConfiguration -ShowColors $false -GlyphSet Unicode
```

### Theme Commands

```powershell
Get-GlyTheme
Get-GlyTheme DefaultDark
Set-GlyTheme DefaultLight
Copy-GlyTheme DefaultDark MyTheme
Register-GlyTheme $theme
```

Built-in themes cannot be overwritten.

`Get-GlyTheme` and `Copy-GlyTheme` return `GlyTheme` values with typed styles, rules, and selectors. `Register-GlyTheme` accepts that type or a compatible hashtable/`pscustomobject`.

### Glyph Set Commands

```powershell
Get-GlyGlyphSet
Get-GlyGlyphSet Unicode
Set-GlyGlyphSet Unicode
Copy-GlyGlyphSet ANSI MyGlyphs
Register-GlyGlyphSet $glyphs
```

Built-in glyph sets cannot be overwritten.

`Get-GlyGlyphSet` and `Copy-GlyGlyphSet` return `GlyGlyphSet` values with typed rules and selectors. `Register-GlyGlyphSet` accepts that type or a compatible hashtable/`pscustomobject`.

### Preview Commands

```powershell
Show-GlyThemeColor
Show-GlyThemeColor DefaultDark
Show-GlyGlyph
Show-GlyGlyph Unicode
Show-GlyThemePreview
Show-GlyThemePreview -Theme DefaultDark -GlyphSet Unicode
```

The commands use the active theme and glyph set when names are omitted. They return one preview object for the fallback and each matcher, and do not alter session configuration.

### Renderer Commands

```powershell
Show-Gly -Path .
Show-GlyTree -Path . -Depth 2
Show-GlyGrid -Path .
```

Aliases:

```powershell
gly
glytr
glygr
```

## Implementation Detail

`Get-GlyFileSystemDisplayName` is exported so PowerShell format data can call it reliably. It is not the primary user-facing API.
