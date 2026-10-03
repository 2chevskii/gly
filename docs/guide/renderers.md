# Renderer Commands

Choose a layout for interactive browsing. Each command uses your current theme and glyph set.

## Show-Gly

Display a list with file details. You can also filter or sort files before displaying them:

```powershell
Show-Gly -Path .
Get-ChildItem . -File | Sort-Object Length -Descending | Show-Gly
```

Alias: `gly`.

## Show-GlyTree

Display folders and their contents as a tree. `-Depth` limits how far the command explores subfolders:

```powershell
Show-GlyTree -Path . -Depth 2
```

Alias: `glytr`.

## Show-GlyGrid

Display names in columns that fit the terminal width:

```powershell
Show-GlyGrid -Path .
```

Alias: `glygr`.

Use `-LiteralPath` for paths containing wildcard characters such as square brackets:

```powershell
Show-Gly -LiteralPath './[archive]'
```

For further file processing, pass the results of `Get-ChildItem` or `Get-Item` to the next command. Use these layouts when you are ready to display the results.
