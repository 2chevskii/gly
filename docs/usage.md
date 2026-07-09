# Использование gly

`gly` - PowerShell-модуль для визуального форматирования объектов файловой системы:

- `System.IO.FileInfo`
- `System.IO.DirectoryInfo`

Модуль рассчитан на PowerShell `7+`. Windows PowerShell `5.1` в MVP не поддерживается.

## Импорт

```powershell
Import-Module ./src/gly.psd1 -Force
```

При импорте модуль автоматически вызывает `Enable-Gly` и загружает format data для стандартного табличного вывода `FileInfo` / `DirectoryInfo`.

Стандартный view сохраняет колонки:

- `Mode`
- `LastWriteTime`
- `Length`
- `Name`

В MVP меняется только колонка `Name`: добавляется glyph и, если разрешено, цвет.

## Быстрый старт

```powershell
Get-ChildItem .
Get-Item .
```

Для явного интерактивного вывода можно использовать renderer-команды:

```powershell
Show-Gly -Path .
Show-GlyTree -Path . -Depth 2
Show-GlyGrid -Path .
```

Короткие aliases:

```powershell
gly .
glytr . -Depth 2
glygr .
```

## Конфигурация

Текущая конфигурация хранится только в памяти текущей PowerShell-сессии:

```powershell
Get-GlyConfiguration
```

Примеры:

```powershell
Set-GlyConfiguration -ShowColors $false
Set-GlyConfiguration -ShowGlyphs $false
Set-GlyConfiguration -SizeFormat Binary
Set-GlyConfiguration -DateFormat Iso
```

`Disable-Gly` отключает стили и glyphs на уровне конфигурации:

```powershell
Disable-Gly
```

`Enable-Gly` включает модуль обратно:

```powershell
Enable-Gly
```

## Renderer backend

`StyleRenderer` управляет способом вывода цвета:

- `Auto`
- `PSStyle`
- `Ansi`
- `PlainText`

Можно использовать preference-переменную `$GlyStyleRenderer`; она имеет приоритет над конфигурацией:

```powershell
$GlyStyleRenderer = 'PlainText'
```

Чтобы сбросить override:

```powershell
Remove-Variable GlyStyleRenderer -Scope Global
```

Если `RespectNoColor = $true` и задана переменная окружения `NO_COLOR`, модуль использует plain text.

## Пример для профиля

```powershell
Import-Module gly
Set-GlyGlyphSet Unicode
Set-GlyTheme DefaultDark
```
