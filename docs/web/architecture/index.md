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

- parses module types and functions as one combined script block to minimize import overhead;
- initializes session configuration;
- registers compact built-in theme and glyph-set definitions;
- calls `Enable-Gly`.

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

Registration commands accept hashtables and `pscustomobject` values, validate them, and convert them before storage. Getter and copy commands return detached typed copies. Built-in themes, Nerd Fonts, and Emoji share one complete selector catalog; ANSI, ANSICompact, and Unicode use its essential structural subset.
