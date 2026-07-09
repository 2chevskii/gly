# Configuration

`gly` configuration is stored only in memory for the current PowerShell session.

```powershell
Get-GlyConfiguration
```

Default MVP configuration:

```powershell
@{
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
```

## Common Changes

Disable colors:

```powershell
Set-GlyConfiguration -ShowColors $false
```

Disable glyphs:

```powershell
Set-GlyConfiguration -ShowGlyphs $false
```

Use binary size formatting in renderer commands:

```powershell
Set-GlyConfiguration -SizeFormat Binary
```

Use ISO-like dates in renderer commands:

```powershell
Set-GlyConfiguration -DateFormat Iso
```

## Style Renderer

`StyleRenderer` controls how color sequences are produced:

- `Auto`
- `PSStyle`
- `Ansi`
- `PlainText`

Set it through configuration:

```powershell
Set-GlyConfiguration -StyleRenderer PlainText
```

Or use the global preference variable:

```powershell
$GlyStyleRenderer = 'PlainText'
```

`$GlyStyleRenderer` has priority over the module configuration. Remove it to return to configuration-based behavior:

```powershell
Remove-Variable GlyStyleRenderer -Scope Global
```

## NO_COLOR

If `RespectNoColor` is enabled and the `NO_COLOR` environment variable exists, `gly` uses plain text rendering.

```powershell
$env:NO_COLOR = '1'
```

Disable this behavior:

```powershell
Set-GlyConfiguration -RespectNoColor $false
```

