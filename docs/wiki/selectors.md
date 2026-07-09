# Селекторы

Темы и наборы глифов используют `GlySelector`, чтобы выбрать правило для `FileInfo` или `DirectoryInfo`.

## Поля

| Поле | Значение и сопоставление |
| --- | --- |
| `Kind` | `File`, `Directory`, `Symlink`, `Junction` или `Other`. Регистр учитывается при регистрации из hashtable. |
| `Name` | Точное имя файла или каталога; регистр учитывается. |
| `Extension` | Одно расширение или массив. Начальная точка необязательна, регистр не учитывается, проверяется конец имени; compound extensions поддерживаются. |
| `Glob` | Один PowerShell wildcard или массив. Регистр не учитывается, шаблон проверяется для `Name` и `FullName`. |
| `Attributes` | Один `System.IO.FileAttributes` или массив, например `Hidden` и `ReadOnly`. |

Все заданные поля должны совпасть. Для массивов `Extension` и `Glob` достаточно одного совпадения, а для `Attributes` объект должен иметь каждый указанный атрибут.

## Порядок правил

Правила проверяются с конца списка: побеждает последнее совпавшее правило. Общие правила размещайте раньше, специфичные — позже.

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

## Встроенный каталог

Встроенные темы и наборы глифов разделяют каталог из более чем 60 правил. Он покрывает:

- основные виды и атрибуты: `Directory`, `Junction`, `Symlink`, `ReadOnly`, `Hidden`;
- well-known directories: Git, editor settings, dependencies, source, tests, documentation, build, cache, downloads, media, infrastructure;
- well-known files: Git, Docker/Compose, README, licenses, changelogs, package manifests/lockfiles, project files, formatter/linter settings, CI;
- языки и платформы: PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP, web;
- данные и документы: JSON, YAML, TOML/INI/ENV, XML, Markdown/text/logs, archives, media, office documents, databases, fonts, certificates, binaries.

Точные имена и расширения перечислены в разделе [«Полный каталог встроенных селекторов»](glyph-sets.md#полный-каталог-встроенных-селекторов).

Каталог использует только уже доступные свойства файлового объекта: чтение содержимого, Git-команды и дополнительные filesystem lookups не выполняются.

## Примеры

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

См. [темы](themes.md) и [наборы глифов](glyph-sets.md).
