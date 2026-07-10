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

- parses module types and functions as one combined script block to minimize import overhead;
- initializes configuration;
- registers compact built-in theme and glyph-set definitions;
- calls `Enable-Gly`.

Built-in theme and glyph-set rules are expanded into detached strongly typed objects only when a registry command returns them. Formatting uses the compact immutable definitions directly and resolves their shared selector catalog through a cached index.

## Rule Resolution

Themes and glyph sets use the same selector model:

- `Kind`
- `Name`
- `Extension`
- `Glob`
- `Attributes`

Rules are evaluated from top to bottom. The last matching rule wins.

The built-in resolver indexes kinds, extensions, exact names, globs, and attributes once. User-registered rules retain the general selector evaluator and the same precedence semantics.

The resolver does not read file contents, does not run Git commands, and does not perform expensive file system lookups in the hot path.

## Strongly Typed Models

Module state uses PowerShell classes declared in `src/GlyTypes.ps1`:

- `GlyConfiguration`;
- `GlyTheme`, `GlyThemeRule`, `GlyStyle`;
- `GlyGlyphSet`, `GlyGlyphRule`;
- `GlySelector`.

Registration commands still accept hashtables and `pscustomobject` values. Input is validated and converted before it reaches a registry. Getter and copy commands return detached typed copies, so callers cannot mutate a built-in registry entry through a returned object.

Built-in themes and glyph sets share one selector catalog, keeping their coverage and rule precedence synchronized.

## Session State

The MVP stores state in memory only:

- active configuration;
- registered themes;
- registered glyph sets;
- format data load flag.

Persistent user configuration is intentionally out of scope for the MVP.
