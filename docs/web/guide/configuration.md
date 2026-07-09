# Configuration

Configuration exists only in the current PowerShell session.

```powershell
Get-GlyConfiguration
```

Common settings:

```powershell
Set-GlyConfiguration -ShowColors $false
Set-GlyConfiguration -ShowGlyphs $false
Set-GlyConfiguration -SizeFormat Binary
Set-GlyConfiguration -DateFormat Iso
Set-GlyConfiguration -StyleRenderer PlainText
```

## Renderer Backend

Supported values:

- `Auto`
- `PSStyle`
- `Ansi`
- `PlainText`

The global preference variable has priority over configuration:

```powershell
$GlyStyleRenderer = 'PlainText'
Remove-Variable GlyStyleRenderer -Scope Global
```

If `RespectNoColor` is enabled and `NO_COLOR` exists, `gly` renders plain text.

