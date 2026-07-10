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

## Install from GitHub Packages

GitHub Packages is an authenticated alternative. Create a classic GitHub personal access token with the `read:packages` scope, then register the owner-scoped NuGet feed and install with PSResourceGet:

```powershell
$credential = Get-Credential -UserName 'GITHUB_USERNAME' -Message 'Enter a classic PAT with read:packages'

Register-PSResourceRepository `
  -Name GitHubPackages `
  -Uri 'https://nuget.pkg.github.com/2CHEVSKII/index.json' `
  -Trusted

Install-PSResource `
  -Name gly `
  -Repository GitHubPackages `
  -Scope CurrentUser `
  -Credential $credential

Import-Module gly
```

GitHub Packages requires credentials for installation even when the package visibility is public.

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
