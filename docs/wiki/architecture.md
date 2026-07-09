# Architecture

`gly` is built around PowerShell's native formatting pipeline.

## Format Data

The standard `FileInfo` and `DirectoryInfo` table view is implemented in:

```text
src/formats/FileSystem.format.ps1xml
```

The format data is loaded with:

```powershell
Update-FormatData -PrependPath
```

PowerShell format data is session-wide. It can remain active after `Remove-Module gly` until the PowerShell session ends.

## Module Initialization

`src/gly.psm1`:

- dot-sources private functions;
- dot-sources public functions;
- initializes configuration;
- initializes built-in themes;
- initializes built-in glyph sets;
- calls `Enable-Gly`.

## Rule Resolution

Themes and glyph sets use the same selector model:

- `Kind`
- `Name`
- `Extension`
- `Glob`
- `Attributes`

Rules are evaluated from top to bottom. The last matching rule wins.

The resolver does not read file contents, does not run Git commands, and does not perform expensive file system lookups in the hot path.

## Типизированные модели

Состояние модуля использует PowerShell-классы из `src/GlyTypes.ps1`:

- `GlyConfiguration`;
- `GlyTheme`, `GlyThemeRule`, `GlyStyle`;
- `GlyGlyphSet`, `GlyGlyphRule`;
- `GlySelector`.

Команды регистрации по-прежнему принимают hashtable и `pscustomobject`. Входные данные проверяются и преобразуются до записи в реестр. Getter- и copy-команды возвращают отдельные типизированные копии, поэтому вызывающий код не может изменить встроенную запись через полученный объект.

Встроенные темы и наборы глифов используют единый каталог селекторов, поэтому их покрытие и приоритет правил синхронизированы.

## Session State

The MVP stores state in memory only:

- active configuration;
- registered themes;
- registered glyph sets;
- format data load flag.

Persistent user configuration is intentionally out of scope for the MVP.
