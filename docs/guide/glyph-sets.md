# Glyph Sets

A glyph set defines the symbol shown before a file or directory name. Nerd Fonts provides the complete selector catalog, including dedicated icons for the supported languages and build tools. The text and Unicode fallback sets intentionally use only essential file-system matchers.

## Built-in Sets

| Set | Default file glyph | Purpose |
| --- | --- | --- |
| `NerdFonts` | `` | Full Nerd Font icons; the default set. |
| `ANSI` | `[file]` | Readable ASCII labels for files, directories, links, and attributes. |
| `ANSICompact` | `f` | Compact structural labels. |
| `Unicode` | `□` | Unicode structural symbols without the Private Use Area. |
| `Emoji` | `📄` | Emoji and short text labels. |

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
Show-GlyGlyph Unicode
```

`gly` does not detect the terminal font or switch sets automatically.

`Show-GlyGlyph` displays each glyph beside a mock file-system entry derived from its selector, such as `file.ps1`, `src/`, or `link -> target`.

## Essential Fallback Matchers

`ANSI`, `ANSICompact`, and `Unicode` define matcher-specific glyphs only for directories, junctions, symbolic links, read-only items, and hidden items. All other matches use the set's default file glyph.

## Complete Icon Coverage

`NerdFonts` contains rules for:

- `Directory`, `Junction`, `Symlink`, `ReadOnly`, and `Hidden`;
- Git, editor-config, dependency, source, test, documentation, build, cache, download, media, and infrastructure directories;
- Git, Docker, README, license, changelog, package, project, settings, and CI files;
- PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP, and web files;
- Ada, Assembly, Astro, Clojure, CoffeeScript, Crystal, Dart, D, Elixir, Elm, Erlang, F#, Fortran, GraphQL, Groovy, Haskell, Haxe, Julia, Kotlin, Lua, Nim, Nix, OCaml, Perl, Prisma, PureScript, R, Reason, ReScript, Scala, Solidity, Swift, Terraform, V, WebAssembly, Zig, and other file types with dedicated Nerd Font icons;
- JSON, YAML, TOML/INI/ENV, XML, Markdown, text, and log files;
- archives, images, audio, video, office documents, databases, fonts, certificates, and binaries.

Complete name and extension lists are in the [selector catalog](./selectors.md#built-in-catalog).

Mappings were inspired by [Terminal-Icons](https://github.com/devblackops/Terminal-Icons), [GlyphShell](https://github.com/SemperFu/GlyphShell), and [PSFileIcons](https://github.com/hanthor/PSFileIcons). `gly` uses only file-system object properties and does not add Git-aware or executable-aware behavior.

The expanded Nerd Fonts mappings use the current [Nerd Fonts cheat sheet](https://www.nerdfonts.com/cheat-sheet) as the glyph source.

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
