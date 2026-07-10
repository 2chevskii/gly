# Installation

## Requirements

`gly` targets PowerShell `7.0+`.

Windows PowerShell `5.1` is not supported by the MVP.

## Install from PowerShell Gallery

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
```

The module initializes itself during import by calling `Enable-Gly`.

## Profile Example

```powershell
Import-Module gly
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
