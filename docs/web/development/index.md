# Development

## PowerShell Checks

```powershell
Test-ModuleManifest ./src/gly.psd1
npm test
npm run test:coverage
```

`npm test` creates JUnit XML, CTRF JSON, and a self-contained HTML report in `artifacts/tests/local`. The coverage command also creates a Cobertura report. CI publishes each test and coverage format as a separate artifact, including HTML and Markdown coverage reports, plus the ZIP and NuGet module packages. It rejects line-coverage regressions larger than one percentage point from the latest successful `master` run.

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
