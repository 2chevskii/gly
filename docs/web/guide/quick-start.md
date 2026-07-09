# Quick Start

Import the module:

```powershell
Import-Module ./src/gly/gly.psd1 -Force
```

Use normal PowerShell commands:

```powershell
Get-ChildItem .
Get-Item .
```

`gly` keeps the default table columns and changes only `Name`.

## Renderer Commands

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

