# Installation

## Requirements

`gly` targets PowerShell `7.0+`.

Windows PowerShell `5.1` is not supported by the MVP.

## Import from Repository

```powershell
Import-Module ./src/gly/gly.psd1 -Force
```

The module initializes itself during import by calling `Enable-Gly`.

## Profile Example

```powershell
Import-Module 'C:\path\to\gly\src\gly\gly.psd1'
Set-GlyGlyphSet Unicode
Set-GlyTheme DefaultDark
```

Use `NerdFonts` only when the active terminal font supports Nerd Font glyphs:

```powershell
Set-GlyGlyphSet NerdFonts
```

## Verify

```powershell
Get-Command -Module gly
Get-GlyConfiguration
```

