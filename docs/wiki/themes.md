# Themes

Themes define colors and text style. They do not define glyphs.

Built-in MVP themes:

- `DefaultDark`
- `DefaultLight`
- `NoColor`

List themes:

```powershell
Get-GlyTheme
```

Select a theme:

```powershell
Set-GlyTheme DefaultLight
```

## Theme Structure

Themes are PowerShell `hashtable` or `pscustomobject` values:

```powershell
@{
    Name = 'MyTheme'
    BuiltIn = $false
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

Supported color values in the MVP:

- `#RRGGBB`
- `$null`

## Rule Selectors

Supported selector fields:

- `Kind`
- `Name`
- `Extension`
- `Glob`
- `Attributes`

Rules are applied in order. Later matching rules win over earlier matching rules.

## Custom Theme

Built-in themes are immutable. Copy a built-in theme, edit the copy, and register it under a new name:

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

The MVP does not import themes from `.json`, `.yaml`, `.psd1`, or `.ps1` files.

