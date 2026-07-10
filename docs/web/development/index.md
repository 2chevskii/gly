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

## Repository Maintenance

GitHub repository metadata documents the contribution, support, and security processes:

- [Contributing guidelines](https://github.com/2CHEVSKII/gly/blob/master/.github/CONTRIBUTING.md)
- [Code of Conduct](https://github.com/2CHEVSKII/gly/blob/master/.github/CODE_OF_CONDUCT.md)
- [Security policy](https://github.com/2CHEVSKII/gly/blob/master/.github/SECURITY.md)
- [Support guidance](https://github.com/2CHEVSKII/gly/blob/master/.github/SUPPORT.md)

Issue forms and the pull request template live in `.github`. Dependabot checks npm dependencies and GitHub Actions weekly. Repository administrators should keep private vulnerability reporting, Dependabot security updates, secret scanning, and push protection enabled.
