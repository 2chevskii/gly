# Selectors

A selector specifies which files or folders a custom color or symbol rule applies to. Use selectors when creating a [custom theme](themes.md#custom-theme) or [custom glyph set](glyph-sets.md#custom-glyph-set).

For example, this rule selects files with `.log` or `.trace` extensions:

```powershell
@{
    Selector = @{ Extension = @('.log', '.trace') }
    Glyph = '[log]'
}
```

## Fields

| Field | Behavior |
| --- | --- |
| `Kind` | The item type: `File`, `Directory`, `Symlink`, `Junction`, or `Other`. |
| `Name` | Exact name, matched case-sensitively. |
| `Extension` | A string or array; the dot is optional, matching is case-insensitive, and compound extensions are supported. |
| `Glob` | A PowerShell wildcard or array; matched against `Name` and `FullName` case-insensitively. |
| `Attributes` | One `System.IO.FileAttributes` value or an array; all values must be present. |

When a selector has several fields, all of them must match. If several rules match an item, the last matching rule wins. Append a rule to override an earlier one.

## Built-in Catalog

The built-in rules recognize the names and file types below. `NerdFonts` provides detailed icons for languages and tools. `ANSI`, `ANSICompact`, and `Unicode` use simpler symbols for files, folders, links, and attributes.

### Directories

- Git: `.git`, `.github`;
- settings: `.config`, `.vscode`, `.vscode-insiders`, `.idea`;
- dependencies: `node_modules`, `vendor`, `packages`, `bower_components`;
- source: `src`, `source`, `scripts`;
- tests: `test`, `tests`, `spec`, `specs`, `coverage`;
- documentation: `doc`, `docs`, `documentation`;
- build: `build`, `dist`, `out`, `output`, `artifacts`, `target`, `bin`;
- cache, downloads, image/audio/video, and infrastructure directories.

### Well-known Files

- Git metadata files;
- `Dockerfile*`, `.dockerignore`, Docker Compose, and Compose YAML;
- `README*`, license/copying, and changelog/history;
- Node, Composer, Go, Rust, and Python package files;
- Visual Studio project files, `CMakeLists.txt`, `Makefile`;
- EditorConfig, ESLint, Prettier, TypeScript/JavaScript config;
- GitLab CI, Travis CI, Azure Pipelines, Bitbucket Pipelines, Jenkins.

### Extensions

- PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP, web, and the additional Nerd Fonts language icons listed in [Glyph Sets](./glyph-sets.md#complete-icon-coverage);
- JSON/JSONC, YAML, TOML/INI/CFG/CONF/ENV, XML/XSD/XSL/XAML/PLIST;
- Markdown/text/logs, archives, media, office documents, databases, fonts, certificates, and binaries.

Rules also distinguish directories, junctions, symbolic links, read-only items, and hidden items.
