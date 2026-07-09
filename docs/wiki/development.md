# Development

## Repository Layout

```text
src/gly/
  gly.psd1
  gly.psm1
  formats/
  private/
  public/
tests/
docs/
assets/branding/
```

## Import Smoke Test

```powershell
pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force"
```

## Public Command Check

```powershell
pwsh -NoProfile -Command "Import-Module ./src/gly/gly.psd1 -Force; Get-Command -Module gly"
```

## Pester Tests

```powershell
pwsh -NoProfile -Command "Invoke-Pester ./tests"
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

