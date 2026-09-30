# API Reference

Commands are grouped by task below. To inspect a command's parameters, run `Get-Command <command> -Syntax`, for example:

```powershell
Get-Command Show-GlyTree -Syntax
```

## Core

Inspect settings, update them, or turn formatting on and off. See [Configuration](../guide/configuration.md) for examples.

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

List, select, copy, and register color themes. See [Themes](../guide/themes.md).

## Glyph Sets

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet
Copy-GlyGlyphSet
Register-GlyGlyphSet
```

List, select, copy, and register symbol sets. See [Glyph Sets](../guide/glyph-sets.md).

## Renderers

Display files in a list, tree, or grid. See [Renderer Commands](../guide/renderers.md) for examples.

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
