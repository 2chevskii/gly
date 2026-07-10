# Development

## Repository Layout

```text
src/
  gly.psd1
  gly.psm1
  formats/
  private/
  public/
tests/
docs/
assets/branding/
```

## Release Package

The **Start release** workflow packages the module directly from `src` with `Compress-PSResource`. The resulting `gly.<version>.nupkg` is attached to the draft GitHub Release and later published unchanged to both registries.

## Publish Dry Run

```powershell
npm run module:publish:whatif
```

## Releases

Stable releases are published from a Git tag to PowerShell Gallery, GitHub Packages, and GitHub Releases.

Configure the `PSGALLERY_API_KEY` Actions repository secret before the first release. GitHub Packages uses the workflow's short-lived `GITHUB_TOKEN`; the release workflow grants it `packages: write` only for that publishing job.

To prepare a release:

1. Update `ModuleVersion` and `ReleaseNotes` in `src/gly.psd1`.
2. Merge the release commit and wait for CI to pass.
3. Create and push a stable tag matching `ModuleVersion`, for example `v0.2.0`.
4. Wait for the **Start release** workflow to run the tests, build `gly.<version>.nupkg`, and create a draft GitHub Release containing that package.
5. Review the generated notes and attached package, then publish the draft release.
6. Verify that both jobs in **Finish release** succeed.

Publishing the draft triggers independent PowerShell Gallery and GitHub Packages jobs. Both jobs download and publish the same package attached to the GitHub Release. If one registry is temporarily unavailable, rerun only its failed job; do not recreate the tag or package.

Only stable `vX.Y.Z` tags are accepted. Prerelease publishing is not part of the current release process.

The GitHub Packages feed is scoped to the repository owner:

```text
https://nuget.pkg.github.com/2CHEVSKII/index.json
```

GitHub Packages requires authentication even when a package is public. After the first publication, confirm the package is linked to this repository and set its intended visibility in the package settings.

## Pester Tests

```powershell
npm test
```

The test command writes JUnit XML, CTRF JSON, and a self-contained HTML report to `artifacts/tests/local`. Install the pinned Node.js reporting tools with `npm ci` before the first run.

Collect Cobertura coverage in addition to the test reports:

```powershell
npm run test:coverage
```

CI publishes each report format as a separate artifact: JUnit XML, CTRF JSON, and HTML test reports for each operating system; Cobertura XML, HTML, and Markdown coverage reports; plus the module ZIP and NuGet package. Its job summary combines CTRF test statistics with the coverage results. Coverage may decrease by at most one percentage point compared with the latest successful `master` run; when no previous artifact exists, the first successful run establishes the baseline.

## Performance Benchmarks

Measure `Import-Module` in isolated PowerShell processes:

```powershell
npm run bench:startup
```

Measure display-name, standard table, and renderer performance against generated file-system data:

```powershell
npm run bench:rendering
```

## Documentation Site

Install Node dependencies:

```powershell
npm ci
```

Run VitePress locally:

```powershell
npm run docs:dev
```

Build the site:

```powershell
npm run docs:build
```

Preview the production build:

```powershell
npm run docs:preview
```
