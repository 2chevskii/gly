# Performance Comparison

`gly` includes a reproducible benchmark that compares its standard table-formatting path with [PSFileIcons](https://github.com/hanthor/PSFileIcons), [GlyphShell](https://github.com/SemperFu/GlyphShell), and [Terminal-Icons](https://github.com/devblackops/Terminal-Icons).

## Results

These results are a snapshot from one machine, not a claim that the same ordering will hold in other environments.

| Module | Version | Import median (range) | Standard-table median (range) |
| --- | ---: | ---: | ---: |
| gly | 0.1.0 | 149.28 ms (145.10–156.66) | 1,112.54 ms (1,088.84–1,148.33) |
| PSFileIcons | 0.1.1 | 74.20 ms (72.60–75.82) | 531.04 ms (411.94–861.84) |
| GlyphShell | 0.1.1 | 240.74 ms (226.98–385.63) | 209.85 ms (168.37–363.00) |
| Terminal-Icons | 0.11.0 | 456.42 ms (434.83–517.96) | 649.74 ms (615.41–993.47) |

Lower is better. The run was performed on July 10, 2026, with:

- PowerShell 7.6.3 and .NET 10.0.9;
- Windows 11 Pro 10.0.26200;
- AMD Ryzen 5 5600X 6-Core Processor;
- 32 GB RAM;
- gly commit `4478f67`.

## Method

The comparison harness pins each PowerShell Gallery dependency to the version shown above and generates the same 3,000-item directory for every module. The data contains 60 directories and 2,940 files distributed across PowerShell, C#, JavaScript, TypeScript, JSON, Markdown, archive, text, and unknown extensions.

The two timed operations are:

- **Import:** `Import-Module` in a fresh `pwsh -NoProfile -NonInteractive` process. PowerShell process startup and module download are outside the timed region. The table reports the median of 10 measurements after 2 warmups.
- **Standard table:** the already-enumerated objects are passed through `Format-Table | Out-String -Width 4096`. Module import, object enumeration, and terminal drawing are outside the timed region. The table reports the median of 5 measurements after 1 warmup, with garbage collection requested before each measurement.

Each module's rendering samples run in a separate PowerShell process so its session-wide format and type data cannot affect another module. The benchmark keeps each module's default visual behavior; GlyphShell therefore renders additional columns, while the other modules replace or customize the standard file-system table.

## Reproduce

From the repository root, run:

```powershell
npm run bench:comparison -- --OutputPath ./artifacts/benchmarks/module-comparison.json
```

The command requires PowerShellGet's `Save-PSResource` command and access to PowerShell Gallery. Override sample sizes when investigating variance:

```powershell
npm run bench:comparison -- --ItemCount 1000 -ImportIterations 20 -RenderingIterations 10
```

## Interpretation

The results measure PowerShell import and conversion to formatted text, not interactive terminal paint time, glyph availability, feature breadth, memory use, or output quality. The modules also perform different work and expose different configuration and renderer features. Hardware, operating system, PowerShell and module versions, filesystem cache, security software, theme, and filename distribution can materially change the numbers. Run the harness locally when performance is important to your choice.
