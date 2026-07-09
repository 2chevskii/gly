# Themes

Themes define color and text style.

Built-in themes:

- `DefaultDark`
- `DefaultLight`
- `NoColor`

```powershell
Get-GlyTheme
Set-GlyTheme DefaultLight
```

## Custom Theme

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

Built-in themes cannot be overwritten. Theme file imports are not part of the MVP.

