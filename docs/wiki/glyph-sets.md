# Наборы глифов

Набор глифов определяет символ перед именем файла или каталога. Все встроенные наборы используют один и тот же каталог селекторов и отличаются только символами.

## Встроенные наборы

| Набор | Глиф файла по умолчанию | Назначение |
| --- | --- | --- |
| `NerdFonts` | `` | Полный набор иконок из Nerd Fonts. Используется по умолчанию. |
| `ANSI` | `[file]` | Читаемые ASCII-метки: `[dir]`, `[package]`, `[image]` и другие. Не требует специального шрифта. |
| `ANSICompact` | `f` | Короткие текстовые метки для узких терминалов. |
| `Unicode` | `□` | Символы Unicode без Private Use Area; для некоторых типов используются короткие метки `JS`, `TS`, `PDF`. |
| `Emoji` | `📄` | Цветные emoji и короткие текстовые метки. Фактическая ширина зависит от терминала. |

Просмотреть и выбрать набор:

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
```

Если глифы `NerdFonts` отображаются неправильно, fallback нужно выбрать явно:

```powershell
Set-GlyGlyphSet ANSI
Set-GlyGlyphSet ANSICompact
Set-GlyGlyphSet Unicode
Set-GlyGlyphSet Emoji
```

`gly` не определяет активный шрифт и не переключает наборы автоматически.

## Полный каталог встроенных селекторов

В каждом встроенном наборе есть правила для следующих групп. Более специфичные правила известных имён объявлены после правил расширений и поэтому имеют приоритет.

### Каталоги

| Группа | Имена |
| --- | --- |
| Git | `.git`, `.github` |
| Настройки редакторов | `.config`, `.vscode`, `.vscode-insiders`, `.idea` |
| Зависимости | `node_modules`, `vendor`, `packages`, `bower_components` |
| Исходный код | `src`, `source`, `scripts` |
| Тесты | `test`, `tests`, `spec`, `specs`, `coverage` |
| Документация | `doc`, `docs`, `documentation` |
| Сборка | `build`, `dist`, `out`, `output`, `artifacts`, `target`, `bin` |
| Кеш | `.cache`, `__pycache__`, `.pytest_cache`, `.mypy_cache` |
| Загрузки | `download`, `downloads` |
| Изображения | `image`, `images`, `photo`, `photos`, `picture`, `pictures` |
| Аудио | `audio`, `music`, `songs` |
| Видео | `video`, `videos`, `movie`, `movies` |
| Инфраструктура | `.docker`, `.kube`, `.terraform`, `infra`, `deploy`, `charts` |

Для остальных каталогов используются отдельные правила `Directory`, `Junction` и `Symlink`.

### Известные файлы

| Группа | Шаблоны и имена |
| --- | --- |
| Git | `.gitignore`, `.gitattributes`, `.gitmodules`, `.gitconfig`, `.gitkeep` |
| Docker Compose | `Dockerfile`, `Dockerfile.*`, `.dockerignore`, `docker-compose*.yml`, `docker-compose*.yaml`, `compose*.yml`, `compose*.yaml` |
| Основная документация | `README*`, `LICENSE*`, `LICENCE*`, `COPYING*`, `CHANGELOG*`, `HISTORY*` |
| Пакеты | `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `composer.json`, `composer.lock`, `go.mod`, `go.sum`, `Cargo.toml`, `Cargo.lock`, `requirements.txt`, `pyproject.toml`, `Pipfile` |
| Проекты и сборка | `*.sln`, `*.slnx`, `*.csproj`, `*.fsproj`, `*.vbproj`, `CMakeLists.txt`, `Makefile` |
| Настройки | `.editorconfig`, ESLint/Prettier config-файлы, `tsconfig*.json`, `jsconfig*.json` |
| CI | GitLab CI, Travis CI, Azure Pipelines, Bitbucket Pipelines, `Jenkinsfile` |

### Расширения

| Группа | Поддерживаемые расширения |
| --- | --- |
| PowerShell | `.ps1`, `.psm1`, `.psd1`, `.ps1xml`, `.psc1`, `.pssc` |
| Shell | `.sh`, `.bash`, `.zsh`, `.fish`, `.bat`, `.cmd` |
| .NET | `.cs`, `.csx`, `.fs`, `.fsx`, `.vb` |
| C/C++ | `.c`, `.h`, `.cpp`, `.cc`, `.cxx`, `.hpp` |
| JVM | `.java`, `.class`, `.jar`, `.kt`, `.kts`, `.scala`, `.gradle` |
| JavaScript/TypeScript | `.js`, `.mjs`, `.cjs`, `.ts`, `.d.ts`, `.jsx`, `.tsx` |
| Другие языки | Python/Jupyter, Rust, Go, Ruby, PHP |
| Web | HTML, CSS, Sass, Less, Vue, Svelte |
| Данные и настройки | JSON/JSONC, YAML, TOML, INI, CFG, CONF, ENV, XML/XSD/XSL/XAML/PLIST |
| Текст | Markdown/MDX/RST, TXT/RTF, LOG/TRACE |
| Архивы | TAR и compound TAR, ZIP, GZip, BZip2, XZ, 7z, RAR, TGZ, Zstandard |
| Медиа | распространённые изображения, аудио и видео |
| Документы | PDF, Word/OpenDocument, Excel/CSV/TSV, PowerPoint/OpenDocument |
| Прочее | базы данных/SQL, шрифты, сертификаты/ключи, executable и binary-файлы |

Атрибуты `ReadOnly` и `Hidden` также имеют отдельные правила; правило `Hidden` объявлено последним.

Каталог составлен по устойчивым mappings из reference-проектов:

| Проект | Использованный источник идей |
| --- | --- |
| [devblackops/Terminal-Icons](https://github.com/devblackops/Terminal-Icons) | Well-known directories/files, extension groups и Nerd Font glyphs. |
| [SemperFu/GlyphShell](https://github.com/SemperFu/GlyphShell) | Расширенное покрытие современных project/tool directories и файлов. |
| [hanthor/PSFileIcons](https://github.com/hanthor/PSFileIcons) | Компактное ядро common development, document и media mappings. |

`gly` не добавляет Git-aware или executable-aware поведение: сопоставление использует только имя, расширение, вид и атрибуты объекта.

## Типизированная структура

`Get-GlyGlyphSet` и `Copy-GlyGlyphSet` возвращают `GlyGlyphSet`. Его правила имеют тип `GlyGlyphRule`, а селекторы — `GlySelector`.

Публичная регистрация по-прежнему принимает удобный hashtable или `pscustomobject`; перед сохранением он проверяется и преобразуется в типизированную модель:

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

Если `Default` не задан и ни одно правило не совпало, глиф не добавляется.

## Пользовательский набор

Встроенные наборы неизменяемы. Создайте копию, измените её и зарегистрируйте под новым именем:

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[my-log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

Правила используют общую [модель селекторов](selectors.md).
