# Темы gly

Тема задает цвет и style для файловых объектов. Она не задает glyphs.

Встроенные темы MVP:

- `DefaultDark`
- `DefaultLight`
- `NoColor`

Посмотреть темы:

```powershell
Get-GlyTheme
```

Выбрать тему:

```powershell
Set-GlyTheme DefaultLight
```

## Пользовательская тема

В MVP пользовательские темы регистрируются только из PowerShell-объектов `hashtable` / `pscustomobject`. Импорт из `.json`, `.yaml`, `.psd1` или `.ps1` не поддерживается.

Пример:

```powershell
$theme = Copy-GlyTheme DefaultDark MyDark
$theme.Rules += @{
    Selector = @{ Extension = '.log' }
    Style = @{
        Foreground = '#d79921'
        Background = $null
        Bold = $false
        Italic = $false
        Underline = $false
    }
}

Register-GlyTheme $theme
Set-GlyTheme MyDark
```

Built-in темы считаются неизменяемыми. Их нельзя перезаписать через `Register-GlyTheme`; нужно создать копию с новым именем.

## Правила

Правила применяются сверху вниз. Если подходят несколько правил, побеждает более позднее правило.

Поддерживаемые selector-поля MVP:

- `Kind`
- `Name`
- `Extension`
- `Glob`
- `Attributes`

Поддерживаемый цветовой формат MVP:

- `#RRGGBB`
- `$null`
