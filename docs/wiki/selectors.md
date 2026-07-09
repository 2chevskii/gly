# Selectors

Themes and glyph sets use selectors to choose a rule for a `FileInfo` or `DirectoryInfo` object. A selector is the `Selector` property of a rule.

## Selector Fields

| Field | Value and matching behavior |
| --- | --- |
| `Kind` | One of `File`, `Directory`, `Symlink`, `Junction`, or `Other`. Matching is case-sensitive. |
| `Name` | Exact file or directory name. Matching is case-sensitive. |
| `Extension` | One extension or an array of extensions. A leading dot is optional; matching is case-insensitive and checks the end of the name, so compound extensions such as `.tar.gz` are supported. |
| `Glob` | One PowerShell wildcard pattern or an array of patterns. Matching is case-insensitive against `Name` and `FullName`. |
| `Attributes` | One `System.IO.FileAttributes` value or an array of values, for example `Hidden` or `ReadOnly`. |

All specified selector fields must match. For `Extension` and `Glob` arrays, a match with any value is sufficient. For `Attributes`, the object must have every specified attribute.

## Rule Order

Rules are evaluated in declaration order. When several rules match, the last matching rule wins. Place general rules first and more specific rules later.

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

For a `.log` file, the second rule applies because it is the last matching rule.

## Theme Examples

Style every directory in bold green:

```powershell
@{
    Selector = @{ Kind = 'Directory' }
    Style = @{ Foreground = '#8ec07c'; Bold = $true }
}
```

Style an exact filename:

```powershell
@{
    Selector = @{ Name = 'Dockerfile' }
    Style = @{ Foreground = '#458588' }
}
```

Style hidden, read-only files in a particular path:

```powershell
@{
    Selector = @{
        Kind = 'File'
        Glob = '*\\archive\\*'
        Attributes = @('Hidden', 'ReadOnly')
    }
    Style = @{ Foreground = '#928374'; Italic = $true }
}
```

## Glyph Set Examples

Assign a glyph to PowerShell files:

```powershell
@{
    Selector = @{ Extension = @('ps1', 'psm1', 'psd1') }
    Glyph = '[ps]'
}
```

Assign a glyph to a filename or path matched by a wildcard:

```powershell
@{
    Selector = @{ Glob = @('Dockerfile*', '*\\containers\\*') }
    Glyph = '[docker]'
}
```

Assign a glyph to hidden items:

```powershell
@{
    Selector = @{ Attributes = 'Hidden' }
    Glyph = '[hidden]'
}
```

See [Themes](themes.md) and [Glyph sets](glyph-sets.md) for the complete structures and registration commands.
