# Installation

## Requirements

`gly` targets PowerShell `7.0+`.

Windows PowerShell `5.1` is not supported by the MVP.

Recommended terminals:

- Windows Terminal
- VS Code integrated terminal
- modern ANSI-compatible terminals

The default glyph set is `NerdFonts`. If the active terminal font does not include Nerd Font glyphs, switch to `Unicode`, `ANSI`, `ANSICompact`, or `Emoji`.

## Import from Repository

From the repository root:

```powershell
Import-Module ./src/gly.psd1 -Force
```

The module calls `Enable-Gly` during import. This loads the custom format data and initializes session configuration, built-in themes, and built-in glyph sets.

## Profile Example

During local development, add an explicit path to your PowerShell profile:

```powershell
Import-Module 'C:\path\to\gly\src\gly.psd1'
Set-GlyGlyphSet Unicode
Set-GlyTheme DefaultDark
```

For a terminal using a Nerd Font:

```powershell
Import-Module 'C:\path\to\gly\src\gly.psd1'
Set-GlyGlyphSet NerdFonts
Set-GlyTheme DefaultDark
```

## Verify Import

```powershell
Import-Module ./src/gly.psd1 -Force
Get-Command -Module gly
Get-GlyConfiguration
```

