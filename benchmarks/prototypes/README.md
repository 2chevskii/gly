# C# display-name prototype

Run the isolated comparison with PowerShell 7+:

```powershell
pwsh -NoProfile -File ./benchmarks/prototypes/Measure-GlyPrototype.ps1 -ItemCount 3000 -Iterations 5
```

The script creates disposable file-system data, compiles `GlyDisplayNamePrototype.cs` in memory, and checks every display name and the complete table output against the current module before timing either implementation. It measures the cost of the existing size-formatting bridge separately. The second prototype table uses the native `Length` property and is equivalent only with the default raw-size setting.

Both counts must be positive. The fixture includes named directories, compound extensions, read-only files, and hidden files on Windows and Unix. The benchmark temporarily selects ANSI output even when a global style preference is set, then restores that preference and the production table's precedence. For an even iteration count, the median is the average of the two middle samples. Add `-PassThru` to return the setup timings, parity count, and scenario results as an object instead of a formatted table. Use the fresh process shown above to isolate module configuration and compiled types from an interactive session.

This is an experiment, not a module integration. It handles the built-in NerdFonts glyph set, the DefaultDark theme, ANSI output, and ordinary files and directories. Symbolic links, user-registered rules, other themes and renderers, runtime configuration changes, and binary-size formatting still need implementation and verification. Runtime C# compilation is included in the reported setup time; a packaged assembly would avoid that compilation step.
