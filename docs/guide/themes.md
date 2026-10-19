# Themes

Themes control colors and text style. [Glyph sets](glyph-sets.md) control the symbols beside names.

## Choose and Preview a Theme

Use `DefaultDark` for a dark terminal background or `DefaultLight` for a light one:

```powershell
Set-GlyTheme DefaultLight
Show-GlyThemeColor DefaultLight
Show-GlyThemePreview -Theme DefaultLight -GlyphSet Unicode
```

The color preview shows sample files, folders, and links. The combined preview shows your chosen colors and symbols together.

List the available themes or preview all of them:

```powershell
Get-GlyTheme
Show-GlyThemeColor -All
```

Choose `NoColor` to leave names uncolored. Themes remain active for the current session; add your choice to your [profile](installation.md#load-gly-in-every-session) to reuse it.

## Built-in Themes

<details>
<summary>Show the full theme list</summary>

The module includes 90 themes:

- `DefaultDark`
- `DefaultLight`
- `NoColor`
- `Dracula`
- `Nord`
- `GruvboxDark`
- `GruvboxLight`
- `CatppuccinMocha`
- `CatppuccinLatte`
- `TokyoNight`
- `SolarizedDark`
- `SolarizedLight`
- `CatppuccinFrappe`
- `CatppuccinMacchiato`
- `RosePine`
- `RosePineMoon`
- `RosePineDawn`
- `TokyoNightStorm`
- `TokyoNightMoon`
- `TokyoNightDay`
- `KanagawaWave`
- `KanagawaDragon`
- `KanagawaLotus`
- `EverforestDark`
- `EverforestLight`
- `OneDark`
- `OneLight`
- `OneDarkPro`
- `GitHubDark`
- `GitHubLight`
- `GitHubDimmed`
- `GitHubHighContrast`
- `VSCodeDarkPlus`
- `VSCodeLightPlus`
- `VSCodeHighContrast`
- `JetBrainsDarcula`
- `Monokai`
- `MonokaiPro`
- `Molokai`
- `MaterialDark`
- `MaterialLight`
- `MaterialPalenight`
- `MaterialOcean`
- `Palenight`
- `AyuDark`
- `AyuLight`
- `AyuMirage`
- `NightOwl`
- `LightOwl`
- `Cobalt2`
- `SynthWave84`
- `ShadesOfPurple`
- `Horizon`
- `Omni`
- `NoctisDark`
- `NoctisLight`
- `Andromeda`
- `Aura`
- `EvaDark`
- `EvaLight`
- `CityLights`
- `Jellybeans`
- `PaperColorDark`
- `PaperColorLight`
- `OceanicNext`
- `Sonokai`
- `EdgeDark`
- `EdgeLight`
- `Nightfox`
- `Dayfox`
- `Dawnfox`
- `Nordfox`
- `Carbonfox`
- `FlexokiDark`
- `FlexokiLight`
- `SerendipityDark`
- `SerendipityLight`
- `IcebergDark`
- `IcebergLight`
- `Srcery`
- `Apprentice`
- `Deus`
- `VitesseDark`
- `VitesseLight`
- `Poimandres`
- `Spacegray`
- `Gotham`
- `Flatland`
- `ParaisoDark`
- `ParaisoLight`

</details>

The palettes are adapted for file listings. See the [palette sources](../development/theme-sources.md) for attribution.

## Essential Color Rules

Built-in color themes use only filesystem-oriented colors so that output remains readable instead of assigning arbitrary colors to every recognized file type.

| Group | Main coverage |
| --- | --- |
| `File` | Files and fallback. |
| `Directory` | Directories. |
| `Symlink` | Symbolic links and junctions. |
| `Hidden` | Items with the hidden attribute. |
| `ReadOnly` | Items with the read-only attribute. |

Recognized extensions and well-known names use the default file color. `NoColor` has no rules and no foreground/background color.

## Custom Theme

Copy a theme under a new name, append a rule, and register your copy. This example gives `.log` files an amber color:

```powershell
$theme = Copy-GlyTheme DefaultDark MyDark
$theme.Rules += @{
    Selector = @{ Extension = '.log' }
    Style = @{
        Foreground = '#d79921'
        Background = $null
        Bold = $false
        Italic = $false
        Underline = $false
    }
}

Register-GlyTheme $theme
Set-GlyTheme MyDark
```

Built-in themes cannot be overwritten. Register your copy under a new name. See [Selectors](selectors.md) to match other file types.
