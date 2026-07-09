# Glyph sets gly

Glyph set задает символы, которые добавляются перед именем файла или директории.

Встроенные glyph sets MVP:

- `NerdFonts`
- `ANSI`
- `ANSICompact`
- `Unicode`
- `Emoji`

По умолчанию используется `NerdFonts`.

## Выбор glyph set

```powershell
Get-GlyGlyphSet
Set-GlyGlyphSet Unicode
```

Если терминал или шрифт не отображает Nerd Fonts корректно, выберите другой набор вручную:

```powershell
Set-GlyGlyphSet ANSI
Set-GlyGlyphSet ANSICompact
Set-GlyGlyphSet Unicode
Set-GlyGlyphSet Emoji
```

`gly` не определяет активный font face терминала и не делает автоматический fallback между glyph sets.

## Пользовательский glyph set

В MVP пользовательские glyph sets регистрируются только из PowerShell-объектов `hashtable` / `pscustomobject`.

Пример:

```powershell
$glyphs = Copy-GlyGlyphSet ANSI MyGlyphs
$glyphs.Rules += @{
    Selector = @{ Extension = '.log' }
    Glyph = '[log]'
}

Register-GlyGlyphSet $glyphs
Set-GlyGlyphSet MyGlyphs
```

Built-in glyph sets считаются неизменяемыми. Их нельзя перезаписать через `Register-GlyGlyphSet`; нужно создать копию с новым именем.

## Правила

Правила применяются сверху вниз. Если подходят несколько правил, побеждает более позднее правило.

Если `Default` не задан и ни одно правило не подошло, glyph не добавляется.
