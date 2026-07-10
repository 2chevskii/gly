# gly Wiki

`gly` is a PowerShell module that adds configurable visual formatting to PowerShell file system objects without replacing PowerShell's object pipeline.

It formats:

- `System.IO.FileInfo`
- `System.IO.DirectoryInfo`

The default experience keeps the familiar PowerShell table columns:

- `Mode`
- `LastWriteTime`
- `Length`
- `Name`

Only `Name` is visually enhanced by the MVP. Renderer commands provide additional interactive layouts.

## Contents

- [Installation](installation.md)
- [Quick start](quick-start.md)
- [Configuration](configuration.md)
- [Selectors](selectors.md)
- [Themes](themes.md)
- [Glyph sets](glyph-sets.md)
- [Renderer commands](renderers.md)
- [Theme and glyph previews](previews.md)
- [API reference](api-reference.md)
- [Architecture](architecture.md)
- [Limitations](limitations.md)
- [Troubleshooting](troubleshooting.md)
- [Development](development.md)

## Design Goals

`gly` is intentionally small and PowerShell-native:

- preserve pipeline semantics;
- keep input `FileInfo` and `DirectoryInfo` objects unchanged;
- use PowerShell format data for the standard view;
- store MVP configuration only in memory;
- make terminal-dependent behavior explicit and configurable;
- avoid Git-aware or executable-aware formatting in the MVP.
