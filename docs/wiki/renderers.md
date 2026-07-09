# Renderer Commands

The standard PowerShell table view is implemented with format data and keeps PowerShell's familiar layout. Additional interactive layouts are implemented as commands.

## Show-Gly

`Show-Gly` returns display records for file system objects.

```powershell
Show-Gly -Path .
Show-Gly -LiteralPath '.\file with spaces.txt'
Get-ChildItem . | Show-Gly
```

Alias:

```powershell
gly .
```

`Show-Gly` applies the active theme, active glyph set, selected style renderer, and renderer-only size/date formatting options.

## Show-GlyTree

`Show-GlyTree` prints a simple tree layout.

```powershell
Show-GlyTree -Path . -Depth 2
Get-Item . | Show-GlyTree -Depth 1
```

Alias:

```powershell
glytr . -Depth 2
```

The command controls directory traversal itself. It is not a full replacement for GNU `tree`.

## Show-GlyGrid

`Show-GlyGrid` prints items in columns.

```powershell
Show-GlyGrid -Path .
Get-ChildItem . | Show-GlyGrid
```

Alias:

```powershell
glygr .
```

Grid width is calculated from visible text length after ANSI escape sequences are removed.

