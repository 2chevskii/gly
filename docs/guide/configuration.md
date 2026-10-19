# Configuration

Settings apply to the current PowerShell session. To reuse them when PowerShell starts, add your commands to your [profile](installation.md#load-gly-in-every-session).

## View Your Settings

```powershell
Get-GlyConfiguration
```

## Choose Colors and Symbols

Themes control colors; glyph sets control the symbols beside names:

```powershell
Set-GlyTheme DefaultLight
Set-GlyGlyphSet Unicode
```

Use `DefaultDark` for a dark terminal background or `DefaultLight` for a light one. See [Themes](themes.md) and [Glyph Sets](glyph-sets.md) for previews and custom choices. Press Tab while entering a theme or glyph-set name to complete it.

You can turn colors and symbols off independently:

```powershell
Set-GlyConfiguration -ShowColors $false
Set-GlyConfiguration -ShowGlyphs $false
```

Set either option to `$true` to turn it back on.

## Format Sizes and Dates

```powershell
Set-GlyConfiguration -SizeFormat Binary
Set-GlyConfiguration -DateFormat Iso
```

`Binary` displays file sizes with units such as `KiB` and `MiB`; `Raw` displays the byte count. Size formatting applies to the usual file listing and to `Show-Gly`.

`Iso` uses a consistent year-month-day date format; `Default` uses the usual date format. Date formatting applies to `Show-Gly`.

## Plain Text

To display names without color or text styling:

```powershell
Set-GlyConfiguration -StyleRenderer PlainText
```

Use `-StyleRenderer Auto` to return to automatic styling. Symbols are controlled separately by `ShowGlyphs`.

`gly` also respects the `NO_COLOR` environment variable by default. If it is set, names use plain text. See [Troubleshooting](../troubleshooting/index.md#colors-do-not-appear) if colors are missing unexpectedly.

## Turn Formatting Off

`Disable-Gly` turns off colors and symbols. To turn them back on:

```powershell
Enable-Gly
Set-GlyConfiguration -ShowColors $true -ShowGlyphs $true
```

To restore the standard PowerShell view completely, open a new session without importing `gly`.
