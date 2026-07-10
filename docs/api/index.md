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

## Format Data Bridge

`Get-GlyFileSystemDisplayName` is exported so PowerShell format data can call it. Treat it as an implementation detail rather than the primary user API.
