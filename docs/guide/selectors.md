# Selectors

Themes and glyph sets use the `GlySelector` type.

## Fields

| Field | Behavior |
| --- | --- |
| `Kind` | `File`, `Directory`, `Symlink`, `Junction`, `Other`; case is preserved when registering from a hashtable. |
| `Name` | Exact name, matched case-sensitively. |
| `Extension` | A string or array; the dot is optional, matching is case-insensitive, and compound extensions are supported. |
| `Glob` | A PowerShell wildcard or array; matched against `Name` and `FullName` case-insensitively. |
| `Attributes` | One `System.IO.FileAttributes` value or an array; all values must be present. |

The last matching rule wins.

## Built-in Catalog

The shared built-in catalog for themes and glyph sets contains more than 170 rules. Nerd Fonts maps the extended language and tool rules to dedicated icons; the fallback sets retain their smaller structural matcher set.

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

Rules also distinguish `Directory`, `Junction`, `Symlink`, `ReadOnly`, and `Hidden`. Matching does not read content or run Git.

```powershell
@{
    Selector = @{ Extension = @('.log', '.trace') }
    Glyph = '[log]'
}
```
