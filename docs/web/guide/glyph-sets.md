# Наборы глифов

Набор глифов определяет символ перед именем файла или каталога. Все встроенные наборы имеют одинаковые селекторы и отличаются символами.

## Встроенные наборы

| Набор | Глиф файла | Назначение |
| --- | --- | --- |
| `NerdFonts` | `` | Полные Nerd Font icons; набор по умолчанию. |
| `ANSI` | `[file]` | Читаемые ASCII-метки без требований к шрифту. |
| `ANSICompact` | `f` | Компактные текстовые метки. |
| `Unicode` | `□` | Unicode и короткие метки без Private Use Area. |
| `Emoji` | `📄` | Emoji и короткие текстовые метки. |

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
```

`gly` не определяет шрифт терминала и не переключает наборы автоматически.

## Покрытие селекторов

Каждый встроенный набор содержит правила для:

- `Directory`, `Junction`, `Symlink`, `ReadOnly` и `Hidden`;
- каталогов Git, editor config, dependencies, source, tests, docs, build, cache, downloads, media и infrastructure;
- Git-, Docker-, README-, license-, changelog-, package-, project-, settings- и CI-файлов;
- PowerShell, shell, .NET, C/C++, JVM, JavaScript/TypeScript/React, Python, Rust, Go, Ruby, PHP и web-файлов;
- JSON, YAML, TOML/INI/ENV, XML, Markdown, text и logs;
- archives, images, audio, video, office documents, databases, fonts, certificates и binaries.

Полные списки имён и расширений приведены в [каталоге селекторов](./selectors.md#встроенный-каталог).

Источниками mappings послужили [Terminal-Icons](https://github.com/devblackops/Terminal-Icons), [GlyphShell](https://github.com/SemperFu/GlyphShell) и [PSFileIcons](https://github.com/hanthor/PSFileIcons). `gly` использует только свойства файлового объекта и не добавляет Git-aware или executable-aware поведение.

## Типизированная структура

`Get-GlyGlyphSet` и `Copy-GlyGlyphSet` возвращают `GlyGlyphSet`; вложенные элементы имеют типы `GlyGlyphRule` и `GlySelector`. Hashtable и `pscustomobject`, переданные в `Register-GlyGlyphSet`, валидируются и преобразуются в эти типы.

## Пользовательский набор

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[my-log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

Встроенные наборы нельзя перезаписать.
