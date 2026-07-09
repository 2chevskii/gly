# Quick Start

Install and import the module:

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
```

Run standard PowerShell commands:

```powershell
Get-ChildItem .
Get-Item .
```

The standard table view keeps `Mode`, `LastWriteTime`, `Length`, and `Name`. `gly` changes only `Name` by adding a glyph and optional color.

## Renderer Commands

Use `Show-Gly` for an explicit formatted object display:

```powershell
Show-Gly -Path .
Get-ChildItem . | Show-Gly
```

Use `Show-GlyTree` for a simple tree layout:

```powershell
Show-GlyTree -Path . -Depth 2
```

Use `Show-GlyGrid` for a compact grid:

```powershell
Show-GlyGrid -Path .
```

## Aliases

```powershell
gly .
glytr . -Depth 2
glygr .
```

## Disable Visuals

```powershell
Disable-Gly
```

This disables glyphs and colors through configuration. It does not unload PowerShell format data from the current session.

Re-enable:

```powershell
Enable-Gly
```
