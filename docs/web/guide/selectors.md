# Селекторы

Темы и наборы глифов используют тип `GlySelector`.

## Поля

| Поле | Поведение |
| --- | --- |
| `Kind` | `File`, `Directory`, `Symlink`, `Junction`, `Other`; регистр учитывается при регистрации из hashtable. |
| `Name` | Точное имя с учётом регистра. |
| `Extension` | Строка или массив; точка необязательна, регистр не учитывается, compound extensions поддерживаются. |
| `Glob` | PowerShell wildcard или массив; проверяется для `Name` и `FullName` без учёта регистра. |
| `Attributes` | Один `System.IO.FileAttributes` или массив; должны присутствовать все значения. |

Побеждает последнее совпавшее правило.

## Встроенный каталог

Общий каталог встроенных тем и наборов глифов включает более 60 правил.

### Каталоги

- Git: `.git`, `.github`;
- настройки: `.config`, `.vscode`, `.vscode-insiders`, `.idea`;
- зависимости: `node_modules`, `vendor`, `packages`, `bower_components`;
- исходники: `src`, `source`, `scripts`;
- тесты: `test`, `tests`, `spec`, `specs`, `coverage`;
- документация: `doc`, `docs`, `documentation`;
- сборка: `build`, `dist`, `out`, `output`, `artifacts`, `target`, `bin`;
- кеш, downloads, image/audio/video и infrastructure directories.

### Известные файлы

- Git metadata files;
- `Dockerfile*`, `.dockerignore`, Docker Compose и Compose YAML;
- `README*`, license/copying и changelog/history;
- Node, Composer, Go, Rust и Python package files;
- Visual Studio project files, `CMakeLists.txt`, `Makefile`;
- EditorConfig, ESLint, Prettier, TypeScript/JavaScript config;
- GitLab CI, Travis CI, Azure Pipelines, Bitbucket Pipelines, Jenkins.

### Расширения

- PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP, web;
- JSON/JSONC, YAML, TOML/INI/CFG/CONF/ENV, XML/XSD/XSL/XAML/PLIST;
- Markdown/text/logs, archives, media, office documents, databases, fonts, certificates и binaries.

Правила также различают `Directory`, `Junction`, `Symlink`, `ReadOnly` и `Hidden`. Сопоставление не читает содержимое и не запускает Git.

```powershell
@{
    Selector = @{ Extension = @('.log', '.trace') }
    Glyph = '[log]'
}
```
