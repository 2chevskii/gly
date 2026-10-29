# Performance Comparison

`gly` includes a reproducible benchmark that compares its standard table-formatting path with [PSFileIcons](https://github.com/hanthor/PSFileIcons), [GlyphShell](https://github.com/SemperFu/GlyphShell), and [Terminal-Icons](https://github.com/devblackops/Terminal-Icons).

## Results

These results are a snapshot from one machine, not a claim that the same ordering will hold in other environments.

| Module | Version | Import median (range) | Standard-table median (range) |
| --- | ---: | ---: | ---: |
| gly | 1.1.2 | 206.81 ms (179.86–264.31) | 1,112.54 ms (1,039.14–1,393.83) |
| PSFileIcons | 0.1.1 | 54.90 ms (51.93–69.08) | 573.65 ms (514.97–922.18) |
| GlyphShell | 0.1.1 | 251.76 ms (238.60–276.94) | 225.26 ms (187.89–421.60) |
| Terminal-Icons | 0.11.0 | 417.11 ms (394.15–454.11) | 676.66 ms (659.71–1,037.91) |

Lower is better. The run was performed on October 29, 2026, with:

- PowerShell 7.6.6 and .NET 10.0.12;
- Windows 11 Pro 10.0.26300;
- AMD Ryzen 5 5600X 6-Core Processor;
- 32 GB RAM;
- gly 1.1.2 from commit `acbc596`, using comparison harness commit `6841051`.

The [recorded JSON results](/benchmarks/module-comparison.windows.json) include all summary statistics and environment metadata.

## Method

The comparison harness pins each PowerShell Gallery dependency to the version shown above and generates the same 3,000-item directory for every module. The data contains 60 directories and 2,940 files distributed across PowerShell, C#, JavaScript, TypeScript, JSON, Markdown, archive, text, and unknown extensions.

The two timed operations are:

- **Import:** `Import-Module` in a fresh `pwsh -NoProfile -NonInteractive` process. PowerShell process startup and module download are outside the timed region. The table reports the median of 10 measurements after 2 warmups.
- **Standard table:** the already-enumerated objects are passed through `Format-Table | Out-String -Width 4096`. Module import, object enumeration, and terminal drawing are outside the timed region. The table reports the median of 5 measurements after 1 warmup, with garbage collection requested before each measurement.

Each module's rendering samples run in a separate PowerShell process so its session-wide format and type data cannot affect another module. Workers clear inherited `NO_COLOR` and force `$PSStyle.OutputRendering = 'Ansi'` on PowerShell 7.2 or later so redirection does not strip formatting. They otherwise keep each module's default visual behavior; GlyphShell therefore renders additional columns, while the other modules replace or customize the standard file-system table.

## Reproduce

From the repository root, run:

```powershell
npm run bench:comparison -- --OutputPath ./artifacts/benchmarks/module-comparison.json
```

The command requires Microsoft.PowerShell.PSResourceGet's `Save-PSResource` command and access to PowerShell Gallery. The JSON output includes the UTC measurement time, PowerShell and .NET versions, and operating system alongside each result. Override sample sizes when investigating variance:

```powershell
npm run bench:comparison -- --ItemCount 1000 -ImportIterations 20 -RenderingIterations 10
```

## Interpretation

The results measure PowerShell import and conversion to formatted text, not interactive terminal paint time, glyph availability, feature breadth, memory use, or output quality. The modules also perform different work and expose different configuration and renderer features. Hardware, operating system, PowerShell and module versions, filesystem cache, security software, theme, and filename distribution can materially change the numbers. Run the harness locally when performance is important to your choice.
