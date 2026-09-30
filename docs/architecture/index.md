# Architecture

This contributor reference describes module internals. For installation and everyday use, start with the [user guide](../guide/index.md).

`gly` uses PowerShell's native formatting system for standard `FileInfo` and `DirectoryInfo` output.

## Format Data

The standard table view is defined in:

```text
src/formats/FileSystem.format.ps1xml
```

It is loaded with `Update-FormatData -PrependPath`.

PowerShell format data is session-wide, so the view can remain active after `Remove-Module gly`.

`Get-GlyFileSystemDisplayName` is exported so format data can call it. It supplies the formatted name for the standard table view and the renderer commands.

## Initialization

The module:

- parses module types and functions as one combined script block to minimize import overhead;
- initializes session configuration;
- registers compact built-in theme and glyph-set definitions;
- calls `Enable-Gly`.

The test runner temporarily sets `GLY_PESTER_COVERAGE=1` during coverage analysis so the module dot-sources the same implementation files and Pester can attribute executed commands to their original paths. Normal imports continue to use the combined script block.

Built-in rules are expanded into detached strongly typed objects only when a registry command returns them. Formatting reads the compact immutable definitions directly.

## Rule Resolution

Theme and glyph rules share the same selector model:

- `Kind`
- `Name`
- `Extension`
- `Glob`
- `Attributes`

Rules are applied in order. The last matching rule wins.

The built-in resolver caches an index for kinds, extensions, exact names, globs, and attributes. User-registered rules keep the general selector evaluator and the same precedence semantics.

## Strongly Typed Models

Session state uses `GlyConfiguration`, `GlyTheme`, `GlyThemeRule`, `GlyStyle`, `GlyGlyphSet`, `GlyGlyphRule`, and `GlySelector`.

Registration commands accept hashtables and `pscustomobject` values, validate them, and convert them before storage. Getter and copy commands return detached typed copies. Nerd Fonts and Emoji use the complete selector catalog; built-in themes, ANSI, ANSICompact, and Unicode use its essential structural subset.

## Style Backends

`StyleRenderer` accepts `Auto`, `PSStyle`, `Ansi`, and `PlainText`. The global `$GlyStyleRenderer` preference takes priority over session configuration. With `RespectNoColor` enabled, the presence of `NO_COLOR` requests plain text.

## Visual Sources

Theme attribution is listed in [Theme Palette Sources](../development/theme-sources.md). Source projects retain their own names, licenses, and distribution terms.

Glyph mappings were inspired by [Terminal-Icons](https://github.com/devblackops/Terminal-Icons), [GlyphShell](https://github.com/SemperFu/GlyphShell), and [PSFileIcons](https://github.com/hanthor/PSFileIcons). The expanded Nerd Fonts mappings use the [Nerd Fonts cheat sheet](https://www.nerdfonts.com/cheat-sheet) as the glyph source.
