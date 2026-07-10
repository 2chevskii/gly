# gly

![gly banner](assets/branding/gly-banner.png)

[![CI](https://github.com/2CHEVSKII/gly/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/2CHEVSKII/gly/actions/workflows/ci.yml)
[![Documentation](https://github.com/2CHEVSKII/gly/actions/workflows/docs.yml/badge.svg?branch=master)](https://2chevskii.github.io/gly/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

`gly` is a PowerShell module for customizable visual formatting of file system objects:

- `System.IO.FileInfo`
- `System.IO.DirectoryInfo`

It improves interactive output for `Get-ChildItem`, `Get-Item`, and user commands that return PowerShell file system objects while preserving the object model and pipeline compatibility.

[Documentation](https://2chevskii.github.io/gly/) · [Contributing](CONTRIBUTING.md) · [Security](SECURITY.md) · [Support](SUPPORT.md)

## Status

`gly` currently provides the MVP implementation described in the current user and developer documentation.

The module:

- targets PowerShell `7.0+`;
- activates automatically on `Import-Module`;
- customizes the standard table view only in the `Name` column;
- adds glyphs and optional color to file and directory names;
- provides session-only configuration;
- supports built-in and user-registered themes;
- supports built-in and user-registered glyph sets;
- stores configuration, themes, glyph sets, rules, selectors, and styles in strongly typed models;
- recognizes well-known project files and directories plus common development, document, archive, and media extensions;
- includes `Show-Gly`, `Show-GlyTree`, and `Show-GlyGrid` renderer commands.

Windows PowerShell `5.1` is not supported by the MVP.

## Quick Start

Install the module from PowerShell Gallery:

```powershell
Install-Module -Name gly -Repository PSGallery -Scope CurrentUser
Import-Module gly
```

After import, standard PowerShell file system output uses the custom view:

```powershell
Get-ChildItem .
Get-Item .
```

Use renderer commands for explicit interactive layouts:

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

Preview registered theme colors, glyphs, or their combined appearance for every matcher. Color and glyph previews use mock file and directory names so each rule is easy to recognize:

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

`Disable-Gly` disables colors and glyphs through module configuration. PowerShell format data is session-wide, so the custom view can remain loaded until the session ends.

## Documentation

- [Wiki index](https://github.com/2CHEVSKII/gly/wiki)
- [Installation](https://github.com/2CHEVSKII/gly/wiki/Installation)
- [Quick start](https://github.com/2CHEVSKII/gly/wiki/Quick-start)
- [Configuration](https://github.com/2CHEVSKII/gly/wiki/Configuration)
- [Themes](https://github.com/2CHEVSKII/gly/wiki/Themes)
- [Glyph sets](https://github.com/2CHEVSKII/gly/wiki/Glyph-sets)
- [Renderer commands](https://github.com/2CHEVSKII/gly/wiki/Renderer-commands)
- [API reference](https://github.com/2CHEVSKII/gly/wiki/API-reference)
- [Limitations](https://github.com/2CHEVSKII/gly/wiki/Limitations)
- [Troubleshooting](https://github.com/2CHEVSKII/gly/wiki/Troubleshooting)

## Development

Run the PowerShell test suite:

```powershell
npm test
```

This produces JUnit XML, CTRF JSON, and HTML test reports under `artifacts/tests/local`. Run `npm run test:coverage` to also produce Cobertura coverage data.

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
