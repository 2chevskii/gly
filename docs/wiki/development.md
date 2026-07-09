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

## Gallery Package Layout

PowerShell Gallery publishing expects a module directory named `gly`. Build that layout before publishing:

```powershell
npm run module:pack
```

The package script validates the generated module manifest.

## Publish Dry Run

```powershell
npm run module:publish:whatif
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
