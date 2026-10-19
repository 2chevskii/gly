# Glyph Sets

A glyph is a symbol shown beside a file or folder name. Choose a set that suits your terminal font: detailed icons with `NerdFonts`, ordinary symbols with `Unicode`, or text labels with `ANSI`.

## Built-in Sets

| Set | Default file glyph | Purpose |
| --- | --- | --- |
| `NerdFonts` | `` | Full Nerd Font icons; the default set. |
| `ANSI` | `[file]` | Readable ASCII labels for files, directories, links, and attributes. |
| `ANSICompact` | `f` | Short text labels such as `f` for files. |
| `Unicode` | `□` | Simple symbols for ordinary fonts. |
| `Emoji` | `📄` | Emoji and short text labels. |

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
Show-GlyGlyph Unicode
```

`NerdFonts` requires a Nerd Font selected in your terminal settings. If icons look wrong, choose `Unicode` or `ANSI`. The set stays active for the current session; add your choice to your [profile](installation.md#load-gly-in-every-session) to reuse it.

`Show-GlyGlyph` previews symbols beside sample names such as `file.ps1`, `src/`, and `link -> target`. Use `Show-GlyGlyph -All` to compare all registered sets.

## Simple Symbol Sets

`ANSI`, `ANSICompact`, and `Unicode` use distinct symbols for directories, junctions, symbolic links, read-only items, and hidden items. All other matches use the set's default file glyph.

## Complete Icon Coverage

`NerdFonts` includes detailed icons for common development files, documents, and media.

<details>
<summary>Show icon coverage</summary>

The set contains icons for:

- `Directory`, `Junction`, `Symlink`, `ReadOnly`, and `Hidden`;
- Git, editor-config, dependency, source, test, documentation, build, cache, download, media, and infrastructure directories;
- Git, Docker, README, license, changelog, package, project, settings, and CI files;
- PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP, and web files;
- Ada, Assembly, Astro, Clojure, CoffeeScript, Crystal, Dart, D, Elixir, Elm, Erlang, F#, Fortran, GraphQL, Groovy, Haskell, Haxe, Julia, Kotlin, Lua, Nim, Nix, OCaml, Perl, Prisma, PureScript, R, Reason, ReScript, Scala, Solidity, Swift, Terraform, V, WebAssembly, Zig, and other file types with dedicated Nerd Font icons;
- JSON, YAML, TOML/INI/ENV, XML, Markdown, text, and log files;
- archives, images, audio, video, office documents, databases, fonts, certificates, and binaries.

</details>

Complete name and extension lists are in the [selector catalog](./selectors.md#built-in-catalog).

## Custom Glyph Set

Copy an existing set under a new name, add a rule, and register your copy. This example labels `.log` files with `[my-log]`:

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[my-log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

Built-in sets cannot be overwritten. Register your copy under a new name. See [Selectors](selectors.md) to match other file types.
