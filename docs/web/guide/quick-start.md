# Quick Start

Install and import the module:

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
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
