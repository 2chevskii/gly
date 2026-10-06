# C# display-name prototype

Run the isolated comparison with PowerShell 7+:

```powershell
pwsh -NoProfile -File ./benchmarks/prototypes/Measure-GlyPrototype.ps1 -ItemCount 3000 -Iterations 5
```

The script creates disposable file-system data, compiles `GlyDisplayNamePrototype.cs` in memory, and checks every display name and the complete table output against the current module before timing either implementation. It measures the cost of the existing size-formatting bridge separately. The second prototype table uses the native `Length` property and is equivalent only with the default raw-size setting.

This is an experiment, not a module integration. It handles the built-in NerdFonts glyph set, the DefaultDark theme, ANSI output, and ordinary files and directories. Symbolic links, user-registered rules, other themes and renderers, runtime configuration changes, and binary-size formatting still need implementation and verification. Runtime C# compilation is included in the reported setup time; a packaged assembly would avoid that compilation step.
