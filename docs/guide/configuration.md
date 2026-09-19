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

`SizeFormat` controls file sizes in the standard PowerShell view and in
`Show-Gly`. `Binary` renders values with binary units such as `KiB` and `MiB`.

Theme and glyph-set names complete dynamically for `Set-GlyTheme`,
`Set-GlyGlyphSet`, and the corresponding `Set-GlyConfiguration` parameters.
Items registered during the current session are available on the next completion
request; command validation still rejects unknown names.

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
