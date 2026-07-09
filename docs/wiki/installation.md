# Installation

## Requirements

`gly` targets PowerShell `7.0+`.

Windows PowerShell `5.1` is not supported by the MVP.

Recommended terminals:

- Windows Terminal
- VS Code integrated terminal
- modern ANSI-compatible terminals

The default glyph set is `NerdFonts`. If the active terminal font does not include Nerd Font glyphs, switch to `Unicode`, `ANSI`, `ANSICompact`, or `Emoji`.

## Install from PowerShell Gallery

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
```

The module calls `Enable-Gly` during import. This loads the custom format data and initializes session configuration, built-in themes, and built-in glyph sets.

## Profile Example

For terminals without Nerd Font glyph support:

```powershell
Import-Module gly
Set-GlyGlyphSet Unicode
Set-GlyTheme DefaultDark
```

For a terminal using a Nerd Font:

```powershell
Import-Module gly
Set-GlyGlyphSet NerdFonts
Set-GlyTheme DefaultDark
```

## Verify Import

```powershell
Import-Module gly
Get-Command -Module gly
Get-GlyConfiguration
```
