# Glyph Sets

A glyph set defines the symbol shown before a file or directory name. All built-in sets share the same selectors and differ in their symbols.

## Built-in Sets

| Set | Default file glyph | Purpose |
| --- | --- | --- |
| `NerdFonts` | `` | Full Nerd Font icons; the default set. |
| `ANSI` | `[file]` | Readable ASCII labels without special font requirements. |
| `ANSICompact` | `f` | Compact text labels. |
| `Unicode` | `□` | Unicode symbols and short labels without the Private Use Area. |
| `Emoji` | `📄` | Emoji and short text labels. |

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
```

`gly` does not detect the terminal font or switch sets automatically.

## Selector Coverage

Every built-in set contains rules for:

- `Directory`, `Junction`, `Symlink`, `ReadOnly`, and `Hidden`;
- Git, editor-config, dependency, source, test, documentation, build, cache, download, media, and infrastructure directories;
- Git, Docker, README, license, changelog, package, project, settings, and CI files;
- PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP, and web files;
- JSON, YAML, TOML/INI/ENV, XML, Markdown, text, and log files;
- archives, images, audio, video, office documents, databases, fonts, certificates, and binaries.

Complete name and extension lists are in the [selector catalog](./selectors.md#built-in-catalog).

Mappings were inspired by [Terminal-Icons](https://github.com/devblackops/Terminal-Icons), [GlyphShell](https://github.com/SemperFu/GlyphShell), and [PSFileIcons](https://github.com/hanthor/PSFileIcons). `gly` uses only file-system object properties and does not add Git-aware or executable-aware behavior.

## Strongly Typed Structure

`Get-GlyGlyphSet` and `Copy-GlyGlyphSet` return `GlyGlyphSet`; nested values use `GlyGlyphRule` and `GlySelector`. Hashtables and `pscustomobject` values passed to `Register-GlyGlyphSet` are validated and converted to these types.

## Custom Glyph Set

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[my-log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

Built-in sets cannot be overwritten.
