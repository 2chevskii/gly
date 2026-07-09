# Architecture

`gly` uses PowerShell's native formatting system for standard `FileInfo` and `DirectoryInfo` output.

## Format Data

The standard table view is defined in:

```text
src/formats/FileSystem.format.ps1xml
```

It is loaded with `Update-FormatData -PrependPath`.

PowerShell format data is session-wide, so the view can remain active after `Remove-Module gly`.

## Initialization

The module:

- loads private functions;
- loads public functions;
- initializes session configuration;
- initializes built-in themes;
- initializes built-in glyph sets;
- calls `Enable-Gly`.

## Rule Resolution

Theme and glyph rules share the same selector model:

- `Kind`
- `Name`
- `Extension`
- `Glob`
- `Attributes`

Rules are applied in order. The last matching rule wins.

## Типизированные модели

Состояние сессии использует `GlyConfiguration`, `GlyTheme`, `GlyThemeRule`, `GlyStyle`, `GlyGlyphSet`, `GlyGlyphRule` и `GlySelector`.

Команды регистрации принимают hashtable и `pscustomobject`, проверяют и преобразуют их до сохранения. Getter- и copy-команды возвращают отдельные типизированные копии. Встроенные темы и наборы глифов разделяют один каталог селекторов.
