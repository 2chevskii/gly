# Glyph Sets

Glyph sets define the symbols added before file and directory names.

Built-in MVP glyph sets:

- `NerdFonts`
- `ANSI`
- `ANSICompact`
- `Unicode`
- `Emoji`

The default glyph set is `NerdFonts`.

## Select a Glyph Set

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
```

If Nerd Font glyphs do not render correctly, choose a fallback explicitly:

```powershell
Set-GlyGlyphSet ANSI
Set-GlyGlyphSet ANSICompact
Set-GlyGlyphSet Unicode
Set-GlyGlyphSet Emoji
```

`gly` does not detect the active terminal font and does not automatically fall back between glyph sets.

## Glyph Set Structure

Glyph sets are PowerShell `hashtable` or `pscustomobject` values:

```powershell
@{
    Name = 'MyGlyphs'
    BuiltIn = $false
    Default = '[file]'
    Rules = @(
        @{
            Selector = @{ Kind = 'Directory' }
            Glyph = '[dir]'
        }
    )
}
```

If `Default` is not set and no rule matches, no glyph is added.

## Custom Glyph Set

Built-in glyph sets are immutable. Copy a built-in set, edit the copy, and register it under a new name:

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

