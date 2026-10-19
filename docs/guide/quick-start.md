# Quick Start

In PowerShell 7.0 or later, install and import the module:

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
Set-GlyGlyphSet Unicode
```

Use normal PowerShell commands:

```powershell
Get-ChildItem .
Get-Item .
```

File and folder names now include symbols and theme colors. Your usual filtering, sorting, and pipelines still work. `Unicode` works with ordinary terminal fonts; choose `NerdFonts` if your terminal uses a Nerd Font.

## Choose Colors and Symbols

```powershell
Set-GlyTheme DefaultLight
Show-GlyThemePreview -Theme DefaultLight -GlyphSet Unicode
```

Use `DefaultDark` for a dark terminal background or `DefaultLight` for a light one. See [Themes](themes.md) and [Glyph Sets](glyph-sets.md) for more choices.

## Choose a Layout

Use a list for file details, a tree to explore subfolders, or a grid for a compact view:

```powershell
Show-Gly -Path .
Show-GlyTree -Path . -Depth 2
Show-GlyGrid -Path .
```

Aliases:

```powershell
gly .
glytr . -Depth 2
glygr .
```

## Keep Your Settings

Settings last for the current session. Follow the [profile instructions](installation.md#load-gly-in-every-session) to apply them whenever PowerShell starts.

Use `Disable-Gly` to turn off colors and symbols. See [Configuration](configuration.md) for individual settings and [Troubleshooting](../troubleshooting/index.md) if the display looks wrong.
