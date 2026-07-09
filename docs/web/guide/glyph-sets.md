# Glyph Sets

Glyph sets define the symbols shown before file and directory names.

Built-in glyph sets:

- `NerdFonts`
- `ANSI`
- `ANSICompact`
- `Unicode`
- `Emoji`

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
```

`gly` does not detect the active terminal font and does not automatically fall back between glyph sets.

## Custom Glyph Set

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

