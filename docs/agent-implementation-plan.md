---
title: Пошаговый план реализации gly
status: ready-for-agent
language: ru
module_name: gly
target_powershell: "7.0+"
---

# Пошаговый план реализации gly

Этот документ можно передать агенту-исполнителю как основной implementation brief. Он не заменяет полную спецификацию, а переводит принятые решения в порядок работ.

## 1. Цель MVP

Реализовать PowerShell-модуль `gly`, который:

- автоматически активируется при `Import-Module`;
- добавляет кастомное форматирование для `System.IO.FileInfo` и `System.IO.DirectoryInfo`;
- в стандартном table view сохраняет привычные колонки `Mode`, `LastWriteTime`, `Length`, `Name`;
- по умолчанию изменяет только колонку `Name`, добавляя glyph и цвет;
- поддерживает сессионную конфигурацию;
- поддерживает built-in и пользовательские темы;
- поддерживает built-in и пользовательские glyph sets;
- предоставляет renderer-команды `Show-Gly`, `Show-GlyTree`, `Show-GlyGrid`;
- сохраняет совместимость с PowerShell pipeline и не мутирует входные объекты.

## 2. Что не входит в MVP

Не реализовывать в первой версии:

- Windows PowerShell `5.1`;
- конфигурационные файлы пользователя на диске;
- импорт тем/glyph sets из файловых форматов;
- автоматическое определение Nerd Font;
- автоматическое определение light/dark режима терминала;
- Git-aware статусы;
- выделение executable-файлов;
- полный аналог `eza`, `ls` или `tree`.

Если в процессе реализации возникает соблазн добавить одну из этих возможностей, зафиксировать ее как future work, но не расширять scope.

## 3. Целевая структура репозитория

Создать модуль в `src/gly`:

```text
src/
  gly/
    gly.psd1
    gly.psm1
    formats/
      FileSystem.format.ps1xml
    public/
      Enable-Gly.ps1
      Disable-Gly.ps1
      Get-GlyConfiguration.ps1
      Set-GlyConfiguration.ps1
      Get-GlyTheme.ps1
      Set-GlyTheme.ps1
      Register-GlyTheme.ps1
      Copy-GlyTheme.ps1
      Get-GlyGlyphSet.ps1
      Set-GlyGlyphSet.ps1
      Register-GlyGlyphSet.ps1
      Copy-GlyGlyphSet.ps1
      Show-Gly.ps1
      Show-GlyTree.ps1
      Show-GlyGrid.ps1
    private/
      ConvertTo-GlyAnsiStyle.ps1
      ConvertTo-GlyPSStyle.ps1
      Format-GlyFileDate.ps1
      Format-GlyFileSize.ps1
      Get-GlyFileSystemDisplayName.ps1
      Get-GlyFileSystemGlyph.ps1
      Get-GlyFileSystemKind.ps1
      Get-GlyFileSystemStyle.ps1
      Initialize-GlyConfiguration.ps1
      Initialize-GlyGlyphSets.ps1
      Initialize-GlyThemes.ps1
      Resolve-GlyFileSystemRule.ps1
      Resolve-GlyStyleRenderer.ps1
      Test-GlyAnsiOutputSupported.ps1
      Test-GlyTheme.ps1
      Test-GlyGlyphSet.ps1
    data/
      glyphsets/
      themes/
tests/
  Gly.Tests.ps1
  RuleResolution.Tests.ps1
  ThemeRegistry.Tests.ps1
  GlyphSetRegistry.Tests.ps1
  Rendering.Tests.ps1
```

Файлы можно дробить иначе, если это улучшает читаемость, но публичный API и границы ответственности нужно сохранить.

## 4. Фаза 0 - подготовка

1. Проверить, что доступен PowerShell `7+`:

   ```powershell
   rtk pwsh -NoProfile -Command "$PSVersionTable.PSVersion"
   ```

2. Проверить наличие Pester:

   ```powershell
   rtk pwsh -NoProfile -Command "Get-Module -ListAvailable Pester | Sort-Object Version -Descending | Select-Object -First 1 Name,Version"
   ```

3. Прочитать исходные документы:

   - `docs/spec/full-spec.md`
   - `docs/spec/branding.md`
   - `docs/spec/theme-candidates.md`
   - `.agents/implementation-rules.md`

4. Не начинать с генерации большого кода. Сначала собрать walking skeleton, который импортируется и тестируется.

## 5. Фаза 1 - каркас модуля

1. Создать `src/gly/gly.psd1`.
2. Указать в manifest:

   - `RootModule = 'gly.psm1'`
   - `ModuleVersion = '0.1.0'`
   - `PowerShellVersion = '7.0'`
   - `CompatiblePSEditions = @('Core')`
   - `FunctionsToExport` только для публичных команд MVP
   - `AliasesToExport = @('gly', 'glytr', 'glygr')`

3. Не полагаться только на `FormatsToProcess` в manifest для override стандартного view. Для MVP загрузку format data должен делать `Enable-Gly` через `Update-FormatData -PrependPath`.
4. Создать `src/gly/gly.psm1`.
5. В `gly.psm1`:

   - dot-source private-функции;
   - dot-source public-функции;
   - инициализировать `$script:GlyConfiguration`;
   - инициализировать `$script:GlyThemes`;
   - инициализировать `$script:GlyGlyphSets`;
   - вызвать `Enable-Gly` при импорте.

6. Добавить smoke test: `Import-Module ./src/gly/gly.psd1 -Force` не падает.

## 6. Фаза 2 - конфигурация сессии

Реализовать сессионную конфигурацию:

```powershell
@{
    Enabled = $true
    Theme = 'DefaultDark'
    GlyphSet = 'NerdFonts'
    ShowGlyphs = $true
    ShowColors = $true
    SizeFormat = 'Raw'
    DateFormat = 'Default'
    StyleRenderer = 'Auto'
    RespectNoColor = $true
    ResetAfterName = $true
}
```

Требования:

- `Get-GlyConfiguration` возвращает копию или read-only представление, а не прямую ссылку на внутреннюю mutable-структуру.
- `Set-GlyConfiguration` валидирует значения и меняет только указанные параметры.
- `$GlyStyleRenderer` является публичной preference-переменной пользователя и имеет приоритет над `StyleRenderer` из конфигурации.
- `Disable-Gly` выключает стили/glyphs на уровне конфигурации, но честно не обещает выгрузить format data из текущей сессии.

## 7. Фаза 3 - темы

Реализовать модель темы:

```powershell
@{
    Name = 'DefaultDark'
    BuiltIn = $true
    Default = @{
        Foreground = '#d4d4d4'
        Background = $null
        Bold = $false
        Italic = $false
        Underline = $false
    }
    Rules = @(
        @{
            Selector = @{ Kind = 'Directory' }
            Style = @{ Foreground = '#8ec07c'; Bold = $true }
        }
    )
}
```

Минимальные built-in темы:

- `DefaultDark`
- `DefaultLight`
- `NoColor`

Дополнительные темы из `docs/spec/theme-candidates.md` добавлять только после проверки лицензии и пригодности палитры.

Реализовать команды:

- `Get-GlyTheme`
- `Set-GlyTheme`
- `Register-GlyTheme`
- `Copy-GlyTheme`

Правила:

- built-in тему нельзя перезаписать через `Register-GlyTheme`;
- для изменения built-in темы пользователь делает `Copy-GlyTheme`, редактирует копию и регистрирует под новым именем;
- пользовательские темы в MVP принимаются только как `hashtable` / `pscustomobject`;
- файлы `.json`, `.yaml`, `.psd1`, `.ps1` не поддерживаются.

## 8. Фаза 4 - glyph sets

Реализовать модель glyph set:

```powershell
@{
    Name = 'NerdFonts'
    BuiltIn = $true
    Default = $null
    Rules = @(
        @{
            Selector = @{ Kind = 'Directory' }
            Glyph = '...'
        }
    )
}
```

Built-in glyph sets MVP:

- `NerdFonts`
- `ANSI`
- `ANSICompact`
- `Unicode`
- `Emoji`

Правила:

- `NerdFonts` используется по умолчанию;
- автоматического fallback между glyph sets нет;
- если `Default` не задан и правило не найдено, glyph не добавляется;
- пользовательские glyph sets принимаются только как `hashtable` / `pscustomobject`.

Реализовать команды:

- `Get-GlyGlyphSet`
- `Set-GlyGlyphSet`
- `Register-GlyGlyphSet`
- `Copy-GlyGlyphSet`

## 9. Фаза 5 - rule resolution

Реализовать общий resolver для тем и glyph sets.

Selector-поля MVP:

- `Kind`: `File`, `Directory`, `Symlink`, `Junction`, `HardLink`, `Other`
- `Name`: точное имя файла или директории
- `Extension`: обычное или compound extension, например `.ps1`, `.d.ts`, `.tar.gz`
- `Glob`: wildcard/glob по имени или относительному пути
- `Attributes`: значения `System.IO.FileAttributes`, например `Hidden`, `ReadOnly`, `ReparsePoint`

Политика приоритета:

- правила применяются сверху вниз;
- более позднее правило побеждает более раннее;
- это поведение должно быть покрыто тестами.

Рекомендации:

- для wildcard matching использовать `System.Management.Automation.WildcardPattern`, а не ad-hoc regex;
- extension matching должен учитывать compound extensions до обычного extension;
- не выполнять дополнительных filesystem-запросов в resolver;
- не читать содержимое файлов;
- не выполнять Git-команды.

## 10. Фаза 6 - renderer цвета

Реализовать `Resolve-GlyStyleRenderer`.

Возможные значения:

- `Auto`
- `PSStyle`
- `Ansi`
- `PlainText`

Порядок принятия решения:

1. Если задан `$GlyStyleRenderer`, использовать его.
2. Если `RespectNoColor = $true` и задана переменная окружения `NO_COLOR`, использовать `PlainText`.
3. Если `ShowColors = $false`, использовать `PlainText`.
4. Если renderer задан явно в конфигурации, использовать его после валидации.
5. Для `Auto`: использовать `$PSStyle` на PowerShell `7.2+`, иначе прямой ANSI.

Реализовать:

- `ConvertTo-GlyPSStyle`
- `ConvertTo-GlyAnsiStyle`
- `Test-GlyAnsiOutputSupported`

Поддерживаемая модель стиля:

```powershell
@{
    Foreground = '#8ec07c'
    Background = $null
    Bold = $false
    Italic = $false
    Underline = $false
}
```

Для цветов MVP достаточно поддержать:

- `#RRGGBB`;
- `$null`;
- возможно, небольшие named colors, если это не усложнит код.

Если renderer не может безопасно сгенерировать стиль, вернуть пустую строку и не ломать вывод.

## 11. Фаза 7 - стандартный format view

Создать `src/gly/formats/FileSystem.format.ps1xml`.

Требования к default table view:

- типы: `System.IO.FileInfo`, `System.IO.DirectoryInfo`;
- колонки: `Mode`, `LastWriteTime`, `Length`, `Name`;
- `Mode`, `LastWriteTime`, `Length` должны оставаться максимально близкими к стандартному PowerShell view;
- кастомизация в стандартном view применяется только к `Name`.

Критический момент PowerShell:

`*.format.ps1xml` действует на всю сессию и не живет в обычном module scope. Нельзя вслепую предполагать, что private-функция модуля будет доступна из `ScriptBlock` format view.

Перед финальной архитектурой проверить один из bridge-вариантов:

1. format view вызывает минимальную exported helper-команду, например `Get-GlyFileSystemDisplayName`;
2. format view использует module-qualified exported command;
3. форматирование имени реализовано через другой надежный bridge, который проходит smoke/integration tests.

Выбрать самый узкий рабочий вариант. Если helper приходится экспортировать, документировать его как implementation detail и не включать в пользовательскую документацию как основной API.

Symlink/junction:

- если PowerShell предоставляет target ссылки на объекте, стандартный view не должен его терять;
- ожидаемый вид: `name -> target`;
- отдельное цветовое оформление target оставить на future work.

## 12. Фаза 8 - Show-Gly

Реализовать `Show-Gly`.

Alias: `gly`.

Команда принимает:

- `System.IO.FileInfo` из pipeline;
- `System.IO.DirectoryInfo` из pipeline;
- массивы файловых объектов;
- `-Path`;
- `-LiteralPath`.

Поведение:

- применяет текущую тему;
- применяет текущий glyph set;
- применяет renderer backend;
- использует human-readable настройки размера и даты;
- не мутирует входные объекты;
- предназначена для интерактивного отображения, а не для машинной обработки.

Рекомендуемая стратегия MVP:

1. На входе собрать объекты из pipeline и/или `Get-ChildItem` / `Get-Item` для `-Path` / `-LiteralPath`.
2. Преобразовать каждый объект в display-record `pscustomobject`.
3. Display-record должен содержать уже отформатированные поля, например `Mode`, `LastWriteTime`, `Length`, `Name`.
4. Вернуть эти display-records в pipeline.

Документировать, что `Show-Gly -Path` может использовать стандартные PowerShell-команды для получения объектов.

## 13. Фаза 9 - Show-GlyTree

Реализовать `Show-GlyTree`.

Alias: `glytr`.

MVP-параметры:

- `-Path`
- `-LiteralPath`
- `-Depth`
- pipeline input для `FileInfo` / `DirectoryInfo`

Поведение:

- самостоятельно управляет обходом директорий;
- отображает отступы и branch-маркеры;
- применяет текущую тему/glyph set;
- уважает базовые настройки цвета/glyphs;
- не пытается быть полным аналогом GNU `tree`.

Ограничение:

- не делать Git-aware tree;
- не читать дополнительные метаданные, кроме стандартных файловых свойств.

## 14. Фаза 10 - Show-GlyGrid

Реализовать `Show-GlyGrid`.

Alias: `glygr`.

MVP-поведение:

- принимает pipeline input и `-Path` / `-LiteralPath`;
- отображает элементы в колонках;
- рассчитывает ширину с учетом видимой длины текста, а не длины ANSI-последовательностей;
- применяет текущие theme/glyph set;
- имеет безопасный fallback при неизвестной ширине терминала.

Для расчета видимой ширины понадобится helper, который убирает ANSI escape sequences из строки.

## 15. Фаза 11 - human-readable helpers

Реализовать:

- `Format-GlyFileSize`
- `Format-GlyFileDate`

MVP:

- `SizeFormat = Raw` оставляет стандартное поведение;
- добавить хотя бы `Binary` для KiB/MiB/GiB;
- `DateFormat = Default` оставляет стандартное поведение;
- дополнительные date modes добавлять только если они нужны renderer-командам.

Важно: human-readable форматирование не включается глобально для стандартного `Get-ChildItem` / `Get-Item` table view.

## 16. Фаза 12 - тестирование

Минимальные unit tests:

- выбор glyph по точному имени;
- выбор glyph по compound extension;
- выбор glyph по обычному extension;
- fallback для неизвестного файла;
- отдельное оформление директорий;
- отдельное оформление hidden-файлов;
- отключение glyph;
- отключение цвета;
- неизвестная тема дает контролируемую ошибку или безопасный fallback;
- неизвестный glyph set дает контролируемую ошибку или безопасный fallback;
- позднее правило побеждает более раннее.

Интеграционные tests:

- `Import-Module` не падает;
- `Get-ChildItem` получает кастомный view;
- `Get-Item` получает кастомный view;
- `Show-Gly` принимает pipeline input;
- `Show-Gly -Path` работает;
- `Show-Gly -LiteralPath` работает;
- `gly`, `glytr`, `glygr` созданы как aliases;
- исходные `FileInfo` / `DirectoryInfo` объекты не мутируются.

Рекомендуемые команды:

```powershell
rtk pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force"
rtk pwsh -NoProfile -Command "Invoke-Pester ./tests"
```

Если Pester не установлен, зафиксировать это и выполнить хотя бы smoke checks через `pwsh -NoProfile`.

## 17. Фаза 13 - документация пользователя

Добавить пользовательские документы после появления working MVP:

- `docs/usage.md`
- `docs/themes.md`
- `docs/glyphsets.md`
- `docs/limitations.md`

Обязательно описать:

- требования к Nerd Fonts;
- как переключиться на `ANSI`, `ANSICompact`, `Unicode`, `Emoji`;
- как отключить цвета;
- как работает `$GlyStyleRenderer`;
- почему `Disable-Gly` не может полностью выгрузить format data из текущей сессии;
- примеры для `$PROFILE`.

## 18. Definition of Done для MVP

MVP можно считать реализованным, если:

- модуль импортируется в PowerShell `7+`;
- при импорте активируется стандартный custom view;
- `Name` для `FileInfo` / `DirectoryInfo` получает glyph и цвет;
- `Disable-Gly` выключает glyph/color на уровне конфигурации;
- `Show-Gly`, `Show-GlyTree`, `Show-GlyGrid` доступны и работают на базовых сценариях;
- темы можно получить, выбрать, скопировать и зарегистрировать;
- glyph sets можно получить, выбрать, скопировать и зарегистрировать;
- тесты покрывают rule resolution, registry behavior и smoke import;
- ограничения MVP явно отражены в документации.

## 19. Риски реализации

Главные риски:

- scope и доступность функций из `*.format.ps1xml`;
- ANSI-последовательности могут ломать выравнивание grid/таблиц, если не считать видимую ширину;
- PowerShell format data может оставаться активным после `Remove-Module`;
- терминалы по-разному рендерят glyphs и emoji;
- symlink target нельзя потерять при замене стандартной колонки `Name`.

Каждый риск должен иметь либо тест, либо явное документированное ограничение.

