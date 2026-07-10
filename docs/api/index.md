# API Reference

## Core

```powershell
Enable-Gly
Disable-Gly
Get-GlyConfiguration
Set-GlyConfiguration
```

## Themes

```powershell
Get-GlyTheme
Set-GlyTheme
Copy-GlyTheme
Register-GlyTheme
```

Getter and copy commands return `GlyTheme`; nested values use `GlyStyle`, `GlyThemeRule`, and `GlySelector`.

## Glyph Sets

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet
Copy-GlyGlyphSet
Register-GlyGlyphSet
```

Getter and copy commands return `GlyGlyphSet`; nested values use `GlyGlyphRule` and `GlySelector`.

## Renderers

```powershell
Show-Gly
Show-GlyTree
Show-GlyGrid
```

Aliases:

```powershell
gly
glytr
glygr
```

## Previews

```powershell
Show-GlyThemeColor [-Theme <String>]
Show-GlyThemeColor -All
Show-GlyGlyph [-GlyphSet <String>]
Show-GlyGlyph -All
Show-GlyThemePreview [-Theme <String>] [-GlyphSet <String>]
```

`Show-GlyThemeColor` and `Show-GlyGlyph` use the active configuration by default. Pass `-All` to preview every currently registered theme or glyph set. Preview rows include the source theme or glyph-set name.

## Format Data Bridge

`Get-GlyFileSystemDisplayName` is exported so PowerShell format data can call it. Treat it as an implementation detail rather than the primary user API.
