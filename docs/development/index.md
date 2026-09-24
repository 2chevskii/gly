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

Use `npm test -- --TestType Unit` or `npm test -- --TestType Snapshots` to run one test type. CI runs both types in parallel on each supported operating system and stores their reports separately.

After the test jobs finish, a dedicated CI job combines their CTRF artifacts into the GitHub test summary. Coverage and benchmark summaries are published by a separate job.

The Pester suite includes committed snapshots in `tests/snapshots`. They cover the exported command surface, built-in themes and glyph sets, previews, session configuration, display names, and renderers. Literal output snapshots also cover `Get-Item`, `Get-ChildItem`, `Show-Gly`, `Show-GlyTree`, and `Show-GlyGrid` with a fixed fixture and output width. Separate Windows, Linux, and macOS snapshots preserve platform-specific spacing, file modes, and line endings. CI compares the output with these snapshots on all three platforms. When an intentional behavior change requires new snapshots, regenerate them on each platform with PowerShell 7 and review the diff:

```powershell
$env:GLY_UPDATE_SNAPSHOTS = '1'
Invoke-Pester ./tests/Snapshots.Tests.ps1
Remove-Item Env:GLY_UPDATE_SNAPSHOTS
npm test
```

The **Refresh snapshots** GitHub Actions workflow can be run manually from the Actions tab. It generates snapshots on Linux, Windows, and macOS, then opens or updates a pull request to `master` when the committed snapshots change and starts CI for that branch. Review the diff before merging.

## Performance Benchmarks

```powershell
npm run bench
npm run bench:startup
npm run bench:rendering
```

The combined command runs the independent startup and rendering suites concurrently while each suite keeps its own timed measurements sequential. The startup benchmark uses isolated PowerShell processes. The rendering benchmark covers display-name, standard-table, and renderer paths against generated file-system data. Each rendering scenario runs with the `PSStyle`, `Ansi`, and `PlainText` style backends, and reports the backend in the `StyleRenderer` column for direct comparison.

Pass `-- --OutputPath ./artifacts/benchmarks/local` to the combined command to write `startup.json` and `rendering.json` to that directory.

CI runs both benchmark suites on `ubuntu-26.04`, publishes their median timings in the workflow summary, and stores the JSON results as the `benchmark-results-ubuntu-26.04` artifact. Each run compares matching scenarios with the latest successful `master` push on the same runner image. A scenario fails the regression gate when its median time is more than 20% slower; the first run on a new runner image and newly added scenarios establish a baseline instead.

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

## Research Notes

- [Headless terminal capture](./terminal-capture-research.md): options and a recommended CI design for README screenshots, documentation video, and a generated theme gallery.
