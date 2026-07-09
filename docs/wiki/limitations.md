# Limitations

## PowerShell Version

The MVP supports PowerShell `7.0+`.

Windows PowerShell `5.1` is not supported.

## Session-Wide Format Data

`gly` loads `FileSystem.format.ps1xml` through `Update-FormatData -PrependPath`.

PowerShell applies format data at session scope. After `Remove-Module gly`, the custom view can remain active until the session exits.

`Disable-Gly` disables glyphs and colors through configuration. It does not promise to unload format data.

## No Persistent Configuration

Configuration, custom themes, and custom glyph sets exist only in the current PowerShell session.

The MVP does not write user configuration to disk.

## No Automatic Terminal Detection

The MVP does not detect:

- whether the active terminal font is a Nerd Font;
- whether the terminal background is light or dark;
- which glyph set should be selected;
- whether automatic fallback between glyph sets is needed.

Choose these settings explicitly.

## No Git-Aware Formatting

The MVP does not run Git commands and does not calculate Git status for files.

## No Executable Highlighting

The MVP does not highlight executable files as a separate category.

## No Theme File Imports

The MVP does not import themes or glyph sets from `.json`, `.yaml`, `.psd1`, or `.ps1` files.

Register custom themes and glyph sets from PowerShell objects.

