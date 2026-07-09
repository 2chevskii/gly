# Development

## PowerShell Checks

```powershell
npm run module:pack
pwsh -NoProfile -Command "Invoke-Pester ./tests"
```

## Documentation Site

```powershell
npm ci
npm run docs:dev
npm run docs:build
npm run docs:preview
```

The VitePress source root is `docs/web`.
