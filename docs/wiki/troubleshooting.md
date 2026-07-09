# Troubleshooting

## Glyphs Render as Boxes or Question Marks

The default glyph set is `NerdFonts`. Switch to a glyph set that does not require Nerd Fonts:

```powershell
Set-GlyGlyphSet Unicode
Set-GlyGlyphSet ANSI
Set-GlyGlyphSet ANSICompact
Set-GlyGlyphSet Emoji
```

## Colors Should Be Disabled

Disable colors in configuration:

```powershell
Set-GlyConfiguration -ShowColors $false
```

Or force plain text rendering:

```powershell
$GlyStyleRenderer = 'PlainText'
```

Remove the override:

```powershell
Remove-Variable GlyStyleRenderer -Scope Global
```

## Output Remains Customized After Remove-Module

This is expected. PowerShell format data is session-wide.

Use:

```powershell
Disable-Gly
```

To fully remove the loaded format data, start a new PowerShell session.

## NO_COLOR Disables Styling

If `NO_COLOR` is set and `RespectNoColor` is enabled, `gly` renders plain text:

```powershell
Remove-Item Env:NO_COLOR
```

Or ignore `NO_COLOR`:

```powershell
Set-GlyConfiguration -RespectNoColor $false
```

