# Troubleshooting

## Glyphs Do Not Render

Switch away from `NerdFonts`:

```powershell
Set-GlyGlyphSet Unicode
Set-GlyGlyphSet ANSI
Set-GlyGlyphSet ANSICompact
Set-GlyGlyphSet Emoji
```

## Disable Color

```powershell
Set-GlyConfiguration -ShowColors $false
```

Or force plain text:

```powershell
$GlyStyleRenderer = 'PlainText'
```

## View Remains After Remove-Module

This is expected PowerShell behavior. Format data is session-wide.

Use:

```powershell
Disable-Gly
```

Start a new PowerShell session to fully clear loaded format data.

