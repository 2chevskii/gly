# Glyph Sets

A glyph set defines the symbol shown before a file or directory name. Nerd Fonts and Emoji provide the complete selector catalog. The text and Unicode fallback sets intentionally use only essential file-system matchers.

## Built-in Sets

| Set | Default file glyph | Purpose |
| --- | --- | --- |
| `NerdFonts` | `` | Full Nerd Font icon set; the default. |
| `ANSI` | `[file]` | Readable ASCII labels for files, directories, links, and attributes; no special font required. |
| `ANSICompact` | `f` | Compact structural labels for narrow terminals. |
| `Unicode` | `□` | Unicode structural symbols without the Private Use Area. |
| `Emoji` | `📄` | Emoji and short text labels; actual width depends on the terminal. |

List and select a set:

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
```

Preview every glyph matcher without changing the active set:

```powershell
Show-GlyGlyph Unicode
```

See [Theme and glyph previews](previews.md) for combined previews and pipeline behavior.

If `NerdFonts` glyphs do not render correctly, select a fallback explicitly:

```powershell
Set-GlyGlyphSet ANSI
Set-GlyGlyphSet ANSICompact
Set-GlyGlyphSet Unicode
Set-GlyGlyphSet Emoji
```

`gly` does not detect the active terminal font or switch sets automatically.

## Essential Fallback Matchers

`ANSI`, `ANSICompact`, and `Unicode` define only these matcher-specific glyphs:

- directory;
- junction;
- symbolic link;
- read-only attribute;
- hidden attribute.

All extension, well-known-name, and specialized-directory matches use the set's default file glyph. This keeps fallback output predictable instead of representing dedicated Nerd Font icons with arbitrary abbreviations.

## Complete Built-in Selector Catalog

`NerdFonts` and `Emoji` contain rules for the groups below. More specific well-known-name rules are declared after extension rules and therefore take precedence.

### Directories

| Group | Names |
| --- | --- |
| Git | `.git`, `.github` |
| Editor settings | `.config`, `.vscode`, `.vscode-insiders`, `.idea` |
| Dependencies | `node_modules`, `vendor`, `packages`, `bower_components` |
| Source | `src`, `source`, `scripts` |
| Tests | `test`, `tests`, `spec`, `specs`, `coverage` |
| Documentation | `doc`, `docs`, `documentation` |
| Build | `build`, `dist`, `out`, `output`, `artifacts`, `target`, `bin` |
| Cache | `.cache`, `__pycache__`, `.pytest_cache`, `.mypy_cache` |
| Downloads | `download`, `downloads` |
| Images | `image`, `images`, `photo`, `photos`, `picture`, `pictures` |
| Audio | `audio`, `music`, `songs` |
| Video | `video`, `videos`, `movie`, `movies` |
| Infrastructure | `.docker`, `.kube`, `.terraform`, `infra`, `deploy`, `charts` |

Other directories use separate `Directory`, `Junction`, and `Symlink` rules.

### Well-known Files

| Group | Patterns and names |
| --- | --- |
| Git | `.gitignore`, `.gitattributes`, `.gitmodules`, `.gitconfig`, `.gitkeep` |
| Docker Compose | `Dockerfile`, `Dockerfile.*`, `.dockerignore`, `docker-compose*.yml`, `docker-compose*.yaml`, `compose*.yml`, `compose*.yaml` |
| Core documentation | `README*`, `LICENSE*`, `LICENCE*`, `COPYING*`, `CHANGELOG*`, `HISTORY*` |
| Packages | `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `composer.json`, `composer.lock`, `go.mod`, `go.sum`, `Cargo.toml`, `Cargo.lock`, `requirements.txt`, `pyproject.toml`, `Pipfile` |
| Projects and build | `*.sln`, `*.slnx`, `*.csproj`, `*.fsproj`, `*.vbproj`, `CMakeLists.txt`, `Makefile` |
| Settings | `.editorconfig`, ESLint/Prettier config files, `tsconfig*.json`, `jsconfig*.json` |
| CI | GitLab CI, Travis CI, Azure Pipelines, Bitbucket Pipelines, `Jenkinsfile` |

### Extensions

| Group | Supported extensions |
| --- | --- |
| PowerShell | `.ps1`, `.psm1`, `.psd1`, `.ps1xml`, `.psc1`, `.pssc` |
| Shell | `.sh`, `.bash`, `.zsh`, `.fish`, `.bat`, `.cmd` |
| .NET | `.cs`, `.csx`, `.fs`, `.fsx`, `.vb` |
| C/C++ | `.c`, `.h`, `.cpp`, `.cc`, `.cxx`, `.hpp` |
| JVM | `.java`, `.class`, `.jar`, `.kt`, `.kts`, `.scala`, `.gradle` |
| JavaScript/TypeScript | `.js`, `.mjs`, `.cjs`, `.ts`, `.d.ts`, `.jsx`, `.tsx` |
| Other languages | Python/Jupyter, Rust, Go, Ruby, PHP |
| Web | HTML, CSS, Sass, Less, Vue, Svelte |
| Data and settings | JSON/JSONC, YAML, TOML, INI, CFG, CONF, ENV, XML/XSD/XSL/XAML/PLIST |
| Text | Markdown/MDX/RST, TXT/RTF, LOG/TRACE |
| Archives | TAR and compound TAR, ZIP, GZip, BZip2, XZ, 7z, RAR, TGZ, Zstandard |
| Media | Common image, audio, and video formats |
| Documents | PDF, Word/OpenDocument, Excel/CSV/TSV, PowerPoint/OpenDocument |
| Other | Databases/SQL, fonts, certificates/keys, executable and binary files |

`ReadOnly` and `Hidden` attributes also have dedicated rules; the `Hidden` rule is declared last.

The catalog was assembled from stable mappings in these reference projects:

| Project | Inspiration |
| --- | --- |
| [devblackops/Terminal-Icons](https://github.com/devblackops/Terminal-Icons) | Well-known directories/files, extension groups, and Nerd Font glyphs. |
| [SemperFu/GlyphShell](https://github.com/SemperFu/GlyphShell) | Broader coverage of modern project/tool directories and files. |
| [hanthor/PSFileIcons](https://github.com/hanthor/PSFileIcons) | Compact core of common development, document, and media mappings. |

`gly` does not add Git-aware or executable-aware behavior: matching uses only the object name, extension, kind, and attributes.

## Strongly Typed Structure

`Get-GlyGlyphSet` and `Copy-GlyGlyphSet` return `GlyGlyphSet`. Its rules use `GlyGlyphRule`, and its selectors use `GlySelector`.

Registration still accepts a hashtable or `pscustomobject`; the input is validated and converted to the typed model before storage:

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

Built-in sets are immutable. Copy a set, edit the copy, and register it under a new name:

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[my-log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

Rules use the shared [selector model](selectors.md).
