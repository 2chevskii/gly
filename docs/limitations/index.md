# Limitations

## PowerShell Version

`gly` requires PowerShell 7.0 or later. Windows PowerShell 5.1 is unsupported.

## Session Settings

Settings and custom themes or glyph sets last for the current session. `gly` does not save them to disk or import theme files. Add your setup commands to your [PowerShell profile](../guide/installation.md#load-gly-in-every-session) to apply them in future sessions.

## Fonts and Terminal Colors

Choose a glyph set that your terminal font can display. `gly` does not detect your font or switch symbol sets automatically. See [Glyph Sets](../guide/glyph-sets.md) for choices that work with ordinary fonts.

Choose a theme for your terminal background manually; `gly` does not detect whether it is dark or light.

## File Information

Colors and symbols reflect file names, extensions, and attributes. They do not indicate Git status or whether a file is executable.

## Restoring the Standard View

`Disable-Gly` turns off colors and symbols. The custom table layout can remain after disabling or removing the module. Open a new PowerShell session without importing `gly` to restore the standard view completely.
