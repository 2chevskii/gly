# Selectors

Themes and glyph sets use `GlySelector` to select a rule for a `FileInfo` or `DirectoryInfo` object.

## Fields

| Field | Value and matching behavior |
| --- | --- |
| `Kind` | `File`, `Directory`, `Symlink`, `Junction`, or `Other`. Case is preserved when registering from a hashtable. |
| `Name` | Exact file or directory name; matching is case-sensitive. |
| `Extension` | One extension or an array. The leading dot is optional, matching is case-insensitive, and the end of the name is checked; compound extensions are supported. |
| `Glob` | One PowerShell wildcard or an array. Matching is case-insensitive against `Name` and `FullName`. |
| `Attributes` | One `System.IO.FileAttributes` value or an array, such as `Hidden` and `ReadOnly`. |

All specified fields must match. For `Extension` and `Glob` arrays, any value may match; for `Attributes`, the object must have every specified attribute.

## Rule Order

Rules are evaluated from the end of the list: the last matching rule wins. Put general rules first and specific rules later.

```powershell
Rules = @(
    @{
        Selector = @{ Kind = 'File' }
        Style = @{ Foreground = '#d4d4d4' }
    }
    @{
        Selector = @{ Extension = @('log', '.trace') }
        Style = @{ Foreground = '#d79921' }
    }
)
```

## Built-in Catalog

Built-in themes and glyph sets share a catalog of more than 60 rules. It covers:

- core kinds and attributes: `Directory`, `Junction`, `Symlink`, `ReadOnly`, `Hidden`;
- well-known directories: Git, editor settings, dependencies, source, tests, documentation, build, cache, downloads, media, infrastructure;
- well-known files: Git, Docker/Compose, README, licenses, changelogs, package manifests/lockfiles, project files, formatter/linter settings, CI;
- languages and platforms: PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP, web;
- data and documents: JSON, YAML, TOML/INI/ENV, XML, Markdown/text/logs, archives, media, office documents, databases, fonts, certificates, binaries.

Exact names and extensions are listed in [Complete Built-in Selector Catalog](glyph-sets.md#complete-built-in-selector-catalog).

The catalog uses only properties already available on the file-system object; it does not read content, run Git commands, or perform additional file-system lookups.

## Examples

```powershell
@{
    Selector = @{ Kind = 'Directory' }
    Style = @{ Foreground = '#8ec07c'; Bold = $true }
}
```

```powershell
@{
    Selector = @{
        Kind = 'File'
        Glob = '*\archive\*'
        Attributes = @('Hidden', 'ReadOnly')
    }
    Glyph = '[archived]'
}
```

See [Themes](themes.md) and [Glyph Sets](glyph-sets.md).
