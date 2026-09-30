# gly

![gly banner](assets/branding/gly-banner.png)

[![CI](https://github.com/2CHEVSKII/gly/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/2CHEVSKII/gly/actions/workflows/ci.yml)
[![Documentation](https://github.com/2CHEVSKII/gly/actions/workflows/docs.yml/badge.svg?branch=master)](https://2chevskii.github.io/gly/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

`gly` adds icons and colors to file and directory listings in PowerShell. Choose a theme, customize the symbols, or browse folders in a tree or grid.

Your usual `Get-ChildItem` and `Get-Item` commands keep working, including filtering, sorting, and passing results to other commands.

[Documentation](https://2chevskii.github.io/gly/) · [Contributing](CONTRIBUTING.md) · [Security](SECURITY.md) · [Support](SUPPORT.md)

Requires PowerShell **7.0 or later**.

## Quick Start

Install the module from PowerShell Gallery:

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
```

Formatting starts as soon as you import the module. The default icons require a [Nerd Font](https://www.nerdfonts.com/) selected in your terminal settings. For symbols that work with ordinary fonts, use:

```powershell
Set-GlyGlyphSet Unicode
```

List files and folders with your usual commands:

```powershell
Get-ChildItem .
Get-Item .
```

Choose a list, tree, or grid layout:

```powershell
Show-Gly -Path .
Show-GlyTree -Path . -Depth 2
Show-GlyGrid -Path .
```

Short aliases are available:

```powershell
gly .
glytr . -Depth 2
glygr .
```

Preview colors and symbols using sample file and folder names:

```powershell
Show-GlyThemeColor DefaultDark
Show-GlyGlyph Unicode
Show-GlyThemePreview -Theme DefaultDark -GlyphSet Unicode
```

Use `-All` to preview every currently registered theme or glyph set:

```powershell
Show-GlyThemeColor -All
Show-GlyGlyph -All
```

## Configuration

Configuration is kept only in the current PowerShell session:

```powershell
Get-GlyConfiguration
```

Common settings:

```powershell
Set-GlyConfiguration -ShowColors $false
Set-GlyConfiguration -ShowGlyphs $false
Set-GlyConfiguration -SizeFormat Binary
Set-GlyConfiguration -DateFormat Iso
Set-GlyTheme DefaultLight
Set-GlyGlyphSet Unicode
```

`SizeFormat` applies to file sizes in both the standard PowerShell view and
the explicit `Show-Gly` renderer.

Use `Disable-Gly` to turn off colors and symbols. To restore the standard PowerShell view completely, open a new session without importing `gly`.

To apply your preferred settings in every new session, add the import and configuration commands to your [PowerShell profile](https://2chevskii.github.io/gly/guide/installation#load-gly-in-every-session).

## Documentation

- [Installation and quick start](https://2chevskii.github.io/gly/guide/)
- [Configuration](https://2chevskii.github.io/gly/guide/configuration)
- [Themes](https://2chevskii.github.io/gly/guide/themes) and [glyph sets](https://2chevskii.github.io/gly/guide/glyph-sets)
- [List, tree, and grid layouts](https://2chevskii.github.io/gly/guide/renderers)
- [Command reference](https://2chevskii.github.io/gly/api/)
- [Limitations](https://2chevskii.github.io/gly/limitations/) and [troubleshooting](https://2chevskii.github.io/gly/troubleshooting/)

## Development

Run the PowerShell test suite:

```powershell
npm test
```

This produces JUnit XML, CTRF JSON, and HTML test reports under `artifacts/tests/local`. Run `npm run test:coverage` to also produce Cobertura coverage data.
The suite includes committed output snapshots, checked on Windows and Ubuntu in CI.

Build the VitePress documentation site:

```powershell
npm ci
npm run docs:build
```

Run repeatable startup and rendering benchmarks:

```powershell
npm run bench
npm run bench:startup
npm run bench:rendering
```

The combined command runs the independent startup and rendering suites concurrently.

## Contributing and Support

Contributions are welcome. Read the [contribution guidelines](CONTRIBUTING.md) before opening an issue or pull request. For usage questions, start a [GitHub Discussion](https://github.com/2CHEVSKII/gly/discussions). Please report security vulnerabilities privately as described in the [security policy](SECURITY.md).

## License

MIT. See [LICENSE](LICENSE).
