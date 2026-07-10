# Development

## PowerShell Checks

```powershell
Test-ModuleManifest ./src/gly.psd1
pwsh -NoProfile -Command "Invoke-Pester ./tests"
```

## Performance Benchmarks

```powershell
npm run bench:startup
npm run bench:rendering
```

The startup benchmark uses isolated PowerShell processes. The rendering benchmark covers display-name, standard-table, and renderer paths against generated file-system data.

## Documentation Site

```powershell
npm ci
npm run docs:dev
npm run docs:build
npm run docs:preview
```

The VitePress source root is `docs/web`.
