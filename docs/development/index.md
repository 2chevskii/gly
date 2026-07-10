# Development

## Branch Names

Use short-lived, descriptive branches. Branch names must begin with one of these prefixes:

- `feature/`
- `fix/`
- `hotfix/`
- `chore/`
- `docs/`
- `refactor/`
- `test/`
- `ci/`

For example: `docs/branch-name-policy`.

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

The startup benchmark uses isolated PowerShell processes. The rendering benchmark covers display-name, standard-table, and renderer paths against generated file-system data. Each rendering scenario runs with the `PSStyle`, `Ansi`, and `PlainText` style backends, and reports the backend in the `StyleRenderer` column for direct comparison.

## Documentation Site

```powershell
npm ci
npm run docs:dev
npm run docs:build
npm run docs:preview
```

The VitePress source root is `docs`.

## Repository Maintenance

GitHub repository metadata documents the contribution, support, and security processes:

- [Contributing guidelines](https://github.com/2CHEVSKII/gly/blob/master/.github/CONTRIBUTING.md)
- [Code of Conduct](https://github.com/2CHEVSKII/gly/blob/master/.github/CODE_OF_CONDUCT.md)
- [Security policy](https://github.com/2CHEVSKII/gly/blob/master/.github/SECURITY.md)
- [Support guidance](https://github.com/2CHEVSKII/gly/blob/master/.github/SUPPORT.md)

Issue forms and the pull request template live in `.github`. Dependabot checks npm dependencies and GitHub Actions weekly. Repository administrators should keep private vulnerability reporting, Dependabot security updates, secret scanning, and push protection enabled.
