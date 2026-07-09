# gly

![gly banner](assets/branding/gly-banner.png)

`gly` is a PowerShell module for customizable visual formatting of file system objects:

- `System.IO.FileInfo`
- `System.IO.DirectoryInfo`

It improves interactive output for `Get-ChildItem`, `Get-Item`, and user commands that return PowerShell file system objects while preserving the object model and pipeline compatibility.

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
- includes `Show-Gly`, `Show-GlyTree`, and `Show-GlyGrid` renderer commands.

Windows PowerShell `5.1` is not supported by the MVP.

## Quick Start

Import the module from the repository:

```powershell
Import-Module ./src/gly.psd1 -Force
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

- [Wiki index](docs/wiki/index.md)
- [Installation](docs/wiki/installation.md)
- [Quick start](docs/wiki/quick-start.md)
- [Configuration](docs/wiki/configuration.md)
- [Themes](docs/wiki/themes.md)
- [Glyph sets](docs/wiki/glyph-sets.md)
- [Renderer commands](docs/wiki/renderers.md)
- [API reference](docs/wiki/api-reference.md)
- [Limitations](docs/wiki/limitations.md)
- [Troubleshooting](docs/wiki/troubleshooting.md)

## Development

Run the PowerShell test suite:

```powershell
pwsh -NoProfile -Command "Invoke-Pester ./tests"
```

Build the VitePress documentation site:

```powershell
npm ci
npm run docs:build
```

## License

No repository license has been declared yet.
