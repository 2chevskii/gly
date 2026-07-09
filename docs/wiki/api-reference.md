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

Возвращает отдельную копию конфигурации с типом `GlyConfiguration`.

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

`Get-GlyTheme` и `Copy-GlyTheme` возвращают `GlyTheme` с типизированными стилями, правилами и селекторами. `Register-GlyTheme` принимает этот тип или совместимый hashtable/`pscustomobject`.

### Glyph Set Commands

```powershell
Get-GlyGlyphSet
Get-GlyGlyphSet Unicode
Set-GlyGlyphSet Unicode
Copy-GlyGlyphSet ANSI MyGlyphs
Register-GlyGlyphSet $glyphs
```

Built-in glyph sets cannot be overwritten.

`Get-GlyGlyphSet` и `Copy-GlyGlyphSet` возвращают `GlyGlyphSet` с типизированными правилами и селекторами. `Register-GlyGlyphSet` принимает этот тип или совместимый hashtable/`pscustomobject`.

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
