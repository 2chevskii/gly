# Troubleshooting

## Icons Appear as Boxes or Unexpected Characters

The default `NerdFonts` set requires a Nerd Font selected in your terminal settings. For ordinary fonts, try Unicode symbols:

```powershell
Set-GlyGlyphSet Unicode
```

If those symbols also look wrong, use simple text labels:

```powershell
Set-GlyGlyphSet ANSI
```

See [Glyph Sets](../guide/glyph-sets.md) to compare the available sets.

## Colors Do Not Appear

Check your settings and select a color theme:

```powershell
Get-GlyConfiguration
Enable-Gly
Set-GlyTheme DefaultDark
Set-GlyConfiguration -ShowColors $true -StyleRenderer Auto
```

Use `DefaultLight` if your terminal has a light background. The `NoColor` theme deliberately leaves names uncolored.

If colors are still missing, check for overrides:

```powershell
Get-Item Env:NO_COLOR -ErrorAction SilentlyContinue
Get-Variable GlyStyleRenderer -Scope Global -ErrorAction SilentlyContinue
```

`NO_COLOR` requests plain text. If you want `gly` to ignore it, use `Set-GlyConfiguration -RespectNoColor $false`. If `$GlyStyleRenderer` is set to `PlainText`, remove the override with `Remove-Variable GlyStyleRenderer -Scope Global`.

## Turn Off Colors

```powershell
Set-GlyConfiguration -ShowColors $false
```

To turn off both colors and symbols, use `Disable-Gly`.

## Settings Disappear in a New Session

Settings last for the current session. Add your import and setup commands to your [PowerShell profile](../guide/installation.md#load-gly-in-every-session) to apply them each time PowerShell starts.

## The Custom View Remains After Removing the Module

Use `Disable-Gly` before removing the module to turn off colors and symbols. Open a new PowerShell session without importing `gly` to restore the standard view completely.
