# Installation

## Requirements

`gly` targets PowerShell `7.0+`.

Run `$PSVersionTable.PSVersion` to check your version. Windows PowerShell 5.1 is unsupported; use PowerShell 7.0 or later.

## Install from PowerShell Gallery

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
```

Formatting starts automatically when you import the module.

## Choose Symbols for Your Font

The default `NerdFonts` set requires a Nerd Font selected in your terminal settings. If icons appear as empty boxes, choose `Unicode` for ordinary fonts or `ANSI` for simple text labels:

```powershell
Set-GlyGlyphSet Unicode
```

See [Glyph Sets](glyph-sets.md) for the available choices.

## Load gly in Every Session

Add these lines to your PowerShell profile, the script PowerShell runs when it starts:

```powershell
Import-Module gly
Set-GlyGlyphSet Unicode
Set-GlyTheme DefaultDark
```

Create the profile if needed, then open the path shown by `$PROFILE` in your preferred editor:

```powershell
$PROFILE
if (-not (Test-Path -LiteralPath $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}
```

Paste the import and settings above into that file and save it. They will apply to future sessions that load the profile.

## Verify

```powershell
Get-ChildItem .
```

File and folder names should now have symbols beside them. Run `Get-GlyConfiguration` to inspect your settings.
