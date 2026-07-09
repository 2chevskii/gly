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

## Glyph Sets

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet
Copy-GlyGlyphSet
Register-GlyGlyphSet
```

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

