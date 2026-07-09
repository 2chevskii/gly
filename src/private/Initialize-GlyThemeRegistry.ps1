function Initialize-GlyThemeRegistry {
  $script:GlyThemes = [ordered]@{}

  function New-GlyBuiltInTheme {
    param(
      [Parameter(Mandatory)]
      [string] $Name,

      [Parameter(Mandatory)]
      [string] $File,

      [Parameter(Mandatory)]
      [string] $Directory,

      [Parameter(Mandatory)]
      [string] $Symlink,

      [Parameter(Mandatory)]
      [string] $Hidden,

      [Parameter(Mandatory)]
      [string] $ReadOnly,

      [Parameter(Mandatory)]
      [string] $PowerShell,

      [Parameter(Mandatory)]
      [string] $Json,

      [Parameter(Mandatory)]
      [string] $Markdown
    )

    $palette = @{
      File       = $File
      Directory  = $Directory
      Symlink    = $Symlink
      Hidden     = $Hidden
      ReadOnly   = $ReadOnly
      PowerShell = $PowerShell
      Json       = $Json
      Markdown   = $Markdown
    }

    [pscustomobject]@{
      Name           = $Name
      BuiltIn        = $true
      DefinitionKind = 'Theme'
      Palette        = $palette
      StyleCache     = @{}
      HasRules       = $true
    }
  }

  $defaultDark = New-GlyBuiltInTheme `
    -Name 'DefaultDark' `
    -File '#d4d4d4' `
    -Directory '#8ec07c' `
    -Symlink '#83a598' `
    -Hidden '#928374' `
    -ReadOnly '#fabd2f' `
    -PowerShell '#83a598' `
    -Json '#d3869b' `
    -Markdown '#b8bb26'

  $defaultLight = New-GlyBuiltInTheme `
    -Name 'DefaultLight' `
    -File '#24292f' `
    -Directory '#0969da' `
    -Symlink '#8250df' `
    -Hidden '#6e7781' `
    -ReadOnly '#9a6700' `
    -PowerShell '#0550ae' `
    -Json '#953800' `
    -Markdown '#116329'

  $noColor = [pscustomobject]@{
    Name           = 'NoColor'
    BuiltIn        = $true
    DefinitionKind = 'Theme'
    Palette        = @{ File = $null }
    StyleCache     = @{}
    HasRules       = $false
  }

  $dracula = New-GlyBuiltInTheme `
    -Name 'Dracula' `
    -File '#f8f8f2' `
    -Directory '#50fa7b' `
    -Symlink '#8be9fd' `
    -Hidden '#6272a4' `
    -ReadOnly '#f1fa8c' `
    -PowerShell '#8be9fd' `
    -Json '#ff79c6' `
    -Markdown '#bd93f9'

  $nord = New-GlyBuiltInTheme `
    -Name 'Nord' `
    -File '#d8dee9' `
    -Directory '#88c0d0' `
    -Symlink '#8fbcbb' `
    -Hidden '#4c566a' `
    -ReadOnly '#ebcb8b' `
    -PowerShell '#81a1c1' `
    -Json '#b48ead' `
    -Markdown '#a3be8c'

  $gruvboxDark = New-GlyBuiltInTheme `
    -Name 'GruvboxDark' `
    -File '#ebdbb2' `
    -Directory '#b8bb26' `
    -Symlink '#83a598' `
    -Hidden '#928374' `
    -ReadOnly '#fabd2f' `
    -PowerShell '#8ec07c' `
    -Json '#d3869b' `
    -Markdown '#fe8019'

  $gruvboxLight = New-GlyBuiltInTheme `
    -Name 'GruvboxLight' `
    -File '#3c3836' `
    -Directory '#79740e' `
    -Symlink '#076678' `
    -Hidden '#928374' `
    -ReadOnly '#b57614' `
    -PowerShell '#427b58' `
    -Json '#8f3f71' `
    -Markdown '#af3a03'

  $catppuccinMocha = New-GlyBuiltInTheme `
    -Name 'CatppuccinMocha' `
    -File '#cdd6f4' `
    -Directory '#a6e3a1' `
    -Symlink '#89dceb' `
    -Hidden '#7f849c' `
    -ReadOnly '#f9e2af' `
    -PowerShell '#89b4fa' `
    -Json '#f5c2e7' `
    -Markdown '#cba6f7'

  $catppuccinLatte = New-GlyBuiltInTheme `
    -Name 'CatppuccinLatte' `
    -File '#4c4f69' `
    -Directory '#40a02b' `
    -Symlink '#179299' `
    -Hidden '#8c8fa1' `
    -ReadOnly '#df8e1d' `
    -PowerShell '#1e66f5' `
    -Json '#ea76cb' `
    -Markdown '#8839ef'

  $tokyoNight = New-GlyBuiltInTheme `
    -Name 'TokyoNight' `
    -File '#c0caf5' `
    -Directory '#9ece6a' `
    -Symlink '#7dcfff' `
    -Hidden '#565f89' `
    -ReadOnly '#e0af68' `
    -PowerShell '#7aa2f7' `
    -Json '#bb9af7' `
    -Markdown '#f7768e'

  $solarizedDark = New-GlyBuiltInTheme `
    -Name 'SolarizedDark' `
    -File '#839496' `
    -Directory '#859900' `
    -Symlink '#2aa198' `
    -Hidden '#586e75' `
    -ReadOnly '#b58900' `
    -PowerShell '#268bd2' `
    -Json '#d33682' `
    -Markdown '#cb4b16'

  $solarizedLight = New-GlyBuiltInTheme `
    -Name 'SolarizedLight' `
    -File '#657b83' `
    -Directory '#859900' `
    -Symlink '#2aa198' `
    -Hidden '#93a1a1' `
    -ReadOnly '#b58900' `
    -PowerShell '#268bd2' `
    -Json '#d33682' `
    -Markdown '#cb4b16'

  $additionalThemes = @(
    @{ Name = 'CatppuccinFrappe'; File = '#c6d0f5'; Directory = '#a6d189'; Symlink = '#99d1db'; Hidden = '#838ba7'; ReadOnly = '#e5c890'; PowerShell = '#8caaee'; Json = '#f4b8e4'; Markdown = '#ca9ee6' }
    @{ Name = 'CatppuccinMacchiato'; File = '#cad3f5'; Directory = '#a6da95'; Symlink = '#91d7e3'; Hidden = '#8087a2'; ReadOnly = '#eed49f'; PowerShell = '#8aadf4'; Json = '#f5bde6'; Markdown = '#c6a0f6' }
    @{ Name = 'RosePine'; File = '#e0def4'; Directory = '#31748f'; Symlink = '#9ccfd8'; Hidden = '#6e6a86'; ReadOnly = '#f6c177'; PowerShell = '#c4a7e7'; Json = '#eb6f92'; Markdown = '#ebbcba' }
    @{ Name = 'RosePineMoon'; File = '#e0def4'; Directory = '#3e8fb0'; Symlink = '#9ccfd8'; Hidden = '#6e6a86'; ReadOnly = '#f6c177'; PowerShell = '#c4a7e7'; Json = '#ea9a97'; Markdown = '#ebbcba' }
    @{ Name = 'RosePineDawn'; File = '#575279'; Directory = '#286983'; Symlink = '#56949f'; Hidden = '#9893a5'; ReadOnly = '#ea9d34'; PowerShell = '#907aa9'; Json = '#b4637a'; Markdown = '#d7827e' }
    @{ Name = 'TokyoNightStorm'; File = '#c0caf5'; Directory = '#9ece6a'; Symlink = '#7dcfff'; Hidden = '#565f89'; ReadOnly = '#e0af68'; PowerShell = '#7aa2f7'; Json = '#bb9af7'; Markdown = '#f7768e' }
    @{ Name = 'TokyoNightMoon'; File = '#c8d3f5'; Directory = '#c3e88d'; Symlink = '#86e1fc'; Hidden = '#636da6'; ReadOnly = '#ffc777'; PowerShell = '#82aaff'; Json = '#c099ff'; Markdown = '#ff757f' }
    @{ Name = 'TokyoNightDay'; File = '#3760bf'; Directory = '#485e30'; Symlink = '#166775'; Hidden = '#8990b3'; ReadOnly = '#8c6c3e'; PowerShell = '#2e7de9'; Json = '#9854f1'; Markdown = '#f52a65' }
    @{ Name = 'KanagawaWave'; File = '#dcd7ba'; Directory = '#98bb6c'; Symlink = '#7e9cd8'; Hidden = '#727169'; ReadOnly = '#e6c384'; PowerShell = '#7fb4ca'; Json = '#d27e99'; Markdown = '#ffa066' }
    @{ Name = 'KanagawaDragon'; File = '#c5c9c5'; Directory = '#87a987'; Symlink = '#8ba4b0'; Hidden = '#737c73'; ReadOnly = '#c4b28a'; PowerShell = '#8ea4a2'; Json = '#a292a3'; Markdown = '#b6927b' }
    @{ Name = 'KanagawaLotus'; File = '#545464'; Directory = '#6f894e'; Symlink = '#4d699b'; Hidden = '#8a8980'; ReadOnly = '#77713f'; PowerShell = '#5a7785'; Json = '#b35b79'; Markdown = '#cc6d00' }
    @{ Name = 'EverforestDark'; File = '#d3c6aa'; Directory = '#a7c080'; Symlink = '#7fbbb3'; Hidden = '#859289'; ReadOnly = '#dbbc7f'; PowerShell = '#83c092'; Json = '#d699b6'; Markdown = '#e69875' }
    @{ Name = 'EverforestLight'; File = '#5c6a72'; Directory = '#8da101'; Symlink = '#35a77c'; Hidden = '#939f91'; ReadOnly = '#dfa000'; PowerShell = '#3a94c5'; Json = '#df69ba'; Markdown = '#f57d26' }
    @{ Name = 'OneDark'; File = '#abb2bf'; Directory = '#98c379'; Symlink = '#56b6c2'; Hidden = '#5c6370'; ReadOnly = '#e5c07b'; PowerShell = '#61afef'; Json = '#c678dd'; Markdown = '#e06c75' }
    @{ Name = 'OneLight'; File = '#383a42'; Directory = '#50a14f'; Symlink = '#0184bc'; Hidden = '#a0a1a7'; ReadOnly = '#c18401'; PowerShell = '#4078f2'; Json = '#a626a4'; Markdown = '#e45649' }
    @{ Name = 'OneDarkPro'; File = '#abb2bf'; Directory = '#98c379'; Symlink = '#56b6c2'; Hidden = '#5c6370'; ReadOnly = '#e5c07b'; PowerShell = '#61afef'; Json = '#c678dd'; Markdown = '#e06c75' }
    @{ Name = 'GitHubDark'; File = '#c9d1d9'; Directory = '#3fb950'; Symlink = '#58a6ff'; Hidden = '#8b949e'; ReadOnly = '#d29922'; PowerShell = '#79c0ff'; Json = '#d2a8ff'; Markdown = '#ff7b72' }
    @{ Name = 'GitHubLight'; File = '#24292f'; Directory = '#1a7f37'; Symlink = '#0969da'; Hidden = '#6e7781'; ReadOnly = '#9a6700'; PowerShell = '#0550ae'; Json = '#8250df'; Markdown = '#cf222e' }
    @{ Name = 'GitHubDimmed'; File = '#adbac7'; Directory = '#57ab5a'; Symlink = '#6cb6ff'; Hidden = '#768390'; ReadOnly = '#c69026'; PowerShell = '#6cb6ff'; Json = '#b083f0'; Markdown = '#f47067' }
    @{ Name = 'GitHubHighContrast'; File = '#ffffff'; Directory = '#09b43a'; Symlink = '#71b7ff'; Hidden = '#bdc4cc'; ReadOnly = '#f0b72f'; PowerShell = '#71b7ff'; Json = '#cb9eff'; Markdown = '#ff6a69' }
    @{ Name = 'VSCodeDarkPlus'; File = '#d4d4d4'; Directory = '#4ec9b0'; Symlink = '#9cdcfe'; Hidden = '#808080'; ReadOnly = '#dcdcaa'; PowerShell = '#569cd6'; Json = '#c586c0'; Markdown = '#ce9178' }
    @{ Name = 'VSCodeLightPlus'; File = '#000000'; Directory = '#267f99'; Symlink = '#0070c1'; Hidden = '#808080'; ReadOnly = '#795e26'; PowerShell = '#0000ff'; Json = '#af00db'; Markdown = '#a31515' }
    @{ Name = 'VSCodeHighContrast'; File = '#ffffff'; Directory = '#00ffff'; Symlink = '#569cd6'; Hidden = '#b3b3b3'; ReadOnly = '#ffff00'; PowerShell = '#569cd6'; Json = '#ff00ff'; Markdown = '#ff6666' }
    @{ Name = 'JetBrainsDarcula'; File = '#a9b7c6'; Directory = '#6a8759'; Symlink = '#6897bb'; Hidden = '#808080'; ReadOnly = '#bbb529'; PowerShell = '#6897bb'; Json = '#cc7832'; Markdown = '#9876aa' }
    @{ Name = 'Monokai'; File = '#f8f8f2'; Directory = '#a6e22e'; Symlink = '#66d9ef'; Hidden = '#75715e'; ReadOnly = '#e6db74'; PowerShell = '#66d9ef'; Json = '#ae81ff'; Markdown = '#f92672' }
    @{ Name = 'MonokaiPro'; File = '#fcfcfa'; Directory = '#a9dc76'; Symlink = '#78dce8'; Hidden = '#727072'; ReadOnly = '#ffd866'; PowerShell = '#78dce8'; Json = '#ab9df2'; Markdown = '#ff6188' }
    @{ Name = 'Molokai'; File = '#f8f8f2'; Directory = '#a6e22e'; Symlink = '#66d9ef'; Hidden = '#75715e'; ReadOnly = '#e6db74'; PowerShell = '#66d9ef'; Json = '#ae81ff'; Markdown = '#f92672' }
    @{ Name = 'MaterialDark'; File = '#eeffff'; Directory = '#c3e88d'; Symlink = '#89ddff'; Hidden = '#546e7a'; ReadOnly = '#ffcb6b'; PowerShell = '#82aaff'; Json = '#c792ea'; Markdown = '#f07178' }
    @{ Name = 'MaterialLight'; File = '#90a4ae'; Directory = '#91b859'; Symlink = '#39adb5'; Hidden = '#cfd8dc'; ReadOnly = '#f6a434'; PowerShell = '#6182b8'; Json = '#7c4dff'; Markdown = '#e53935' }
    @{ Name = 'MaterialPalenight'; File = '#a6accd'; Directory = '#c3e88d'; Symlink = '#89ddff'; Hidden = '#676e95'; ReadOnly = '#ffcb6b'; PowerShell = '#82aaff'; Json = '#c792ea'; Markdown = '#f07178' }
    @{ Name = 'MaterialOcean'; File = '#c3cee3'; Directory = '#c3e88d'; Symlink = '#89ddff'; Hidden = '#546e7a'; ReadOnly = '#ffcb6b'; PowerShell = '#82aaff'; Json = '#c792ea'; Markdown = '#f07178' }
    @{ Name = 'Palenight'; File = '#a6accd'; Directory = '#c3e88d'; Symlink = '#89ddff'; Hidden = '#676e95'; ReadOnly = '#ffcb6b'; PowerShell = '#82aaff'; Json = '#c792ea'; Markdown = '#f07178' }
    @{ Name = 'AyuDark'; File = '#b3b1ad'; Directory = '#aad94c'; Symlink = '#39bae6'; Hidden = '#626a73'; ReadOnly = '#ffb454'; PowerShell = '#59c2ff'; Json = '#d2a6ff'; Markdown = '#f07178' }
    @{ Name = 'AyuLight'; File = '#5c6773'; Directory = '#6cbf43'; Symlink = '#55b4d4'; Hidden = '#abb0b6'; ReadOnly = '#ff9940'; PowerShell = '#399ee6'; Json = '#a37acc'; Markdown = '#f07171' }
    @{ Name = 'AyuMirage'; File = '#cbccc6'; Directory = '#bae67e'; Symlink = '#5ccfe6'; Hidden = '#707a8c'; ReadOnly = '#ffd580'; PowerShell = '#73d0ff'; Json = '#d4bfff'; Markdown = '#ff3333' }
    @{ Name = 'NightOwl'; File = '#d6deeb'; Directory = '#addb67'; Symlink = '#7fdbca'; Hidden = '#637777'; ReadOnly = '#ecc48d'; PowerShell = '#82aaff'; Json = '#c792ea'; Markdown = '#ff5874' }
    @{ Name = 'LightOwl'; File = '#403f53'; Directory = '#2aa298'; Symlink = '#08916a'; Hidden = '#989fb1'; ReadOnly = '#daaa01'; PowerShell = '#4876d6'; Json = '#994cc3'; Markdown = '#d3423e' }
    @{ Name = 'Cobalt2'; File = '#ffffff'; Directory = '#3ad900'; Symlink = '#9effff'; Hidden = '#0088ff'; ReadOnly = '#ffc600'; PowerShell = '#1478db'; Json = '#ff9d00'; Markdown = '#ff628c' }
    @{ Name = 'SynthWave84'; File = '#ffffff'; Directory = '#72f1b8'; Symlink = '#36f9f6'; Hidden = '#848bbd'; ReadOnly = '#fede5d'; PowerShell = '#03edf9'; Json = '#ff7edb'; Markdown = '#fe4450' }
    @{ Name = 'ShadesOfPurple'; File = '#ffffff'; Directory = '#a5ff90'; Symlink = '#9effff'; Hidden = '#b362ff'; ReadOnly = '#fad000'; PowerShell = '#6943ff'; Json = '#ff9d00'; Markdown = '#ff628c' }
    @{ Name = 'Horizon'; File = '#d5d8da'; Directory = '#efaf8e'; Symlink = '#24a8b4'; Hidden = '#6c6f93'; ReadOnly = '#fac29a'; PowerShell = '#26bbd9'; Json = '#ee64ac'; Markdown = '#e95678' }
    @{ Name = 'Omni'; File = '#e1e1e6'; Directory = '#67e480'; Symlink = '#78d1e1'; Hidden = '#585858'; ReadOnly = '#e7de79'; PowerShell = '#78d1e1'; Json = '#988bc7'; Markdown = '#ff79c6' }
    @{ Name = 'NoctisDark'; File = '#b5b9c4'; Directory = '#49e9a6'; Symlink = '#16b0c9'; Hidden = '#697098'; ReadOnly = '#e4b781'; PowerShell = '#70e1e8'; Json = '#df769b'; Markdown = '#ff6f6b' }
    @{ Name = 'NoctisLight'; File = '#2f3e4e'; Directory = '#42a77a'; Symlink = '#0097a7'; Hidden = '#9aa5b1'; ReadOnly = '#b66d00'; PowerShell = '#2f80ed'; Json = '#8e44ad'; Markdown = '#d64541' }
    @{ Name = 'Andromeda'; File = '#d5ced9'; Directory = '#95c862'; Symlink = '#00e8c6'; Hidden = '#6e6a86'; ReadOnly = '#ffe66d'; PowerShell = '#00e8c6'; Json = '#c74ded'; Markdown = '#ee5d43' }
    @{ Name = 'Aura'; File = '#edecee'; Directory = '#61ffca'; Symlink = '#82e2ff'; Hidden = '#6d6d6d'; ReadOnly = '#ffca85'; PowerShell = '#82e2ff'; Json = '#a277ff'; Markdown = '#ff6767' }
    @{ Name = 'EvaDark'; File = '#9fa2a6'; Directory = '#66ff66'; Symlink = '#00ffff'; Hidden = '#55799c'; ReadOnly = '#ffff66'; PowerShell = '#00aeff'; Json = '#b45bcf'; Markdown = '#ff6f6f' }
    @{ Name = 'EvaLight'; File = '#4b5263'; Directory = '#379a37'; Symlink = '#008c99'; Hidden = '#9aa5b1'; ReadOnly = '#a98200'; PowerShell = '#0069c2'; Json = '#7a3e9d'; Markdown = '#c43e3e' }
    @{ Name = 'CityLights'; File = '#b7c5d3'; Directory = '#8bd49c'; Symlink = '#70e1e8'; Hidden = '#718ca1'; ReadOnly = '#e6cd69'; PowerShell = '#5ec4ff'; Json = '#b62d65'; Markdown = '#d95468' }
    @{ Name = 'Jellybeans'; File = '#e8e8d3'; Directory = '#99ad6a'; Symlink = '#8fbfdc'; Hidden = '#888888'; ReadOnly = '#fad07a'; PowerShell = '#8197bf'; Json = '#c6b6ee'; Markdown = '#cf6a4c' }
    @{ Name = 'PaperColorDark'; File = '#d0d0d0'; Directory = '#afd700'; Symlink = '#5fafaf'; Hidden = '#808080'; ReadOnly = '#ffaf00'; PowerShell = '#5fafd7'; Json = '#d787d7'; Markdown = '#d75f5f' }
    @{ Name = 'PaperColorLight'; File = '#444444'; Directory = '#008700'; Symlink = '#0087af'; Hidden = '#878787'; ReadOnly = '#af5f00'; PowerShell = '#005faf'; Json = '#8700af'; Markdown = '#af0000' }
    @{ Name = 'OceanicNext'; File = '#c0c5ce'; Directory = '#99c794'; Symlink = '#5fb3b3'; Hidden = '#65737e'; ReadOnly = '#fac863'; PowerShell = '#6699cc'; Json = '#c594c5'; Markdown = '#ec5f67' }
    @{ Name = 'Sonokai'; File = '#e2e2e3'; Directory = '#9ed072'; Symlink = '#76cce0'; Hidden = '#7f8490'; ReadOnly = '#e7c664'; PowerShell = '#76cce0'; Json = '#b39df3'; Markdown = '#fc5d7c' }
    @{ Name = 'EdgeDark'; File = '#c5cdd9'; Directory = '#a1bf78'; Symlink = '#5ebaa5'; Hidden = '#6b7089'; ReadOnly = '#dbb774'; PowerShell = '#73b3e7'; Json = '#d390e7'; Markdown = '#e98989' }
    @{ Name = 'EdgeLight'; File = '#4b505b'; Directory = '#608e32'; Symlink = '#3a8b84'; Hidden = '#8790a0'; ReadOnly = '#a76b00'; PowerShell = '#5079be'; Json = '#b05ccc'; Markdown = '#bf616a' }
    @{ Name = 'Nightfox'; File = '#cdcecf'; Directory = '#81b29a'; Symlink = '#63cdcf'; Hidden = '#738091'; ReadOnly = '#f4a261'; PowerShell = '#719cd6'; Json = '#9d79d6'; Markdown = '#c94f6d' }
    @{ Name = 'Dayfox'; File = '#34455a'; Directory = '#618774'; Symlink = '#287980'; Hidden = '#a8aeb7'; ReadOnly = '#a06000'; PowerShell = '#2e7de9'; Json = '#9854f1'; Markdown = '#b15c5c' }
    @{ Name = 'Dawnfox'; File = '#575279'; Directory = '#618774'; Symlink = '#286983'; Hidden = '#9893a5'; ReadOnly = '#ea9d34'; PowerShell = '#56949f'; Json = '#907aa9'; Markdown = '#b4637a' }
    @{ Name = 'Nordfox'; File = '#cdcecf'; Directory = '#a3be8c'; Symlink = '#8fbcbb'; Hidden = '#60728a'; ReadOnly = '#ebcb8b'; PowerShell = '#81a1c1'; Json = '#b48ead'; Markdown = '#bf616a' }
    @{ Name = 'Carbonfox'; File = '#f2f4f8'; Directory = '#25be6a'; Symlink = '#33b1ff'; Hidden = '#6e7781'; ReadOnly = '#f1c21b'; PowerShell = '#78a9ff'; Json = '#be95ff'; Markdown = '#ee5396' }
    @{ Name = 'FlexokiDark'; File = '#cecdc3'; Directory = '#879a39'; Symlink = '#3aa99f'; Hidden = '#878580'; ReadOnly = '#d0a215'; PowerShell = '#4385be'; Json = '#ce5d97'; Markdown = '#d14d41' }
    @{ Name = 'FlexokiLight'; File = '#100f0f'; Directory = '#66800b'; Symlink = '#24837b'; Hidden = '#b7b5ac'; ReadOnly = '#ad8301'; PowerShell = '#205ea6'; Json = '#a02f6f'; Markdown = '#af3029' }
    @{ Name = 'SerendipityDark'; File = '#dee0f0'; Directory = '#72d5a3'; Symlink = '#7bdff2'; Hidden = '#8f95b2'; ReadOnly = '#f8c555'; PowerShell = '#78c2ff'; Json = '#c3a6ff'; Markdown = '#f08aa5' }
    @{ Name = 'SerendipityLight'; File = '#4a4a5e'; Directory = '#4f9f69'; Symlink = '#2b8c9f'; Hidden = '#a1a6bd'; ReadOnly = '#b88700'; PowerShell = '#2b6fcb'; Json = '#8f63c7'; Markdown = '#c04f6f' }
    @{ Name = 'IcebergDark'; File = '#c6c8d1'; Directory = '#b4be82'; Symlink = '#89b8c2'; Hidden = '#6b7089'; ReadOnly = '#e2a478'; PowerShell = '#84a0c6'; Json = '#a093c7'; Markdown = '#e27878' }
    @{ Name = 'IcebergLight'; File = '#33374c'; Directory = '#668e3d'; Symlink = '#3f83a6'; Hidden = '#8389a3'; ReadOnly = '#b6662d'; PowerShell = '#2d539e'; Json = '#7759b4'; Markdown = '#cc517a' }
    @{ Name = 'Srcery'; File = '#fce8c3'; Directory = '#98bc37'; Symlink = '#68a8e4'; Hidden = '#918175'; ReadOnly = '#fed06e'; PowerShell = '#2c78bf'; Json = '#ff5c8f'; Markdown = '#ef2f27' }
    @{ Name = 'Apprentice'; File = '#bcbcbc'; Directory = '#87af87'; Symlink = '#87afd7'; Hidden = '#6c6c6c'; ReadOnly = '#ffffaf'; PowerShell = '#5fafd7'; Json = '#8787af'; Markdown = '#af5f5f' }
    @{ Name = 'Deus'; File = '#b3b3b3'; Directory = '#98c379'; Symlink = '#56b6c2'; Hidden = '#666666'; ReadOnly = '#e5c07b'; PowerShell = '#61afef'; Json = '#c678dd'; Markdown = '#e06c75' }
    @{ Name = 'VitesseDark'; File = '#dbd7ca'; Directory = '#4d9375'; Symlink = '#5eaab5'; Hidden = '#666666'; ReadOnly = '#c98a7d'; PowerShell = '#6394bf'; Json = '#d19a66'; Markdown = '#cb7676' }
    @{ Name = 'VitesseLight'; File = '#393a34'; Directory = '#59873a'; Symlink = '#2c7a7b'; Hidden = '#a0ada0'; ReadOnly = '#b08800'; PowerShell = '#2f6f9f'; Json = '#a65e2b'; Markdown = '#ab5959' }
    @{ Name = 'Poimandres'; File = '#a6accd'; Directory = '#5de4c7'; Symlink = '#89ddff'; Hidden = '#767c9d'; ReadOnly = '#fffac2'; PowerShell = '#add7ff'; Json = '#fcc5e9'; Markdown = '#d0679d' }
    @{ Name = 'Spacegray'; File = '#b3b8c3'; Directory = '#a6bc69'; Symlink = '#7cafc2'; Hidden = '#5f6672'; ReadOnly = '#fac863'; PowerShell = '#6a9fb5'; Json = '#ba8baf'; Markdown = '#c594c5' }
    @{ Name = 'Gotham'; File = '#98d1ce'; Directory = '#2aa889'; Symlink = '#599cab'; Hidden = '#245361'; ReadOnly = '#edb54b'; PowerShell = '#195466'; Json = '#888ca6'; Markdown = '#c23127' }
    @{ Name = 'Flatland'; File = '#b8dbef'; Directory = '#a7d42c'; Symlink = '#4fb4d7'; Hidden = '#555555'; ReadOnly = '#ffcc66'; PowerShell = '#61b9d0'; Json = '#e09fb5'; Markdown = '#f2777a' }
    @{ Name = 'ParaisoDark'; File = '#a39e9b'; Directory = '#48b685'; Symlink = '#5bc4bf'; Hidden = '#776e71'; ReadOnly = '#fec418'; PowerShell = '#06b6ef'; Json = '#815ba4'; Markdown = '#ef6155' }
    @{ Name = 'ParaisoLight'; File = '#2f1e2e'; Directory = '#48b685'; Symlink = '#5bc4bf'; Hidden = '#8d8687'; ReadOnly = '#f99b15'; PowerShell = '#06b6ef'; Json = '#815ba4'; Markdown = '#ef6155' }
  ) | ForEach-Object {
    New-GlyBuiltInTheme `
      -Name $_.Name `
      -File $_.File `
      -Directory $_.Directory `
      -Symlink $_.Symlink `
      -Hidden $_.Hidden `
      -ReadOnly $_.ReadOnly `
      -PowerShell $_.PowerShell `
      -Json $_.Json `
      -Markdown $_.Markdown
  }

  foreach ($theme in @(
      $defaultDark,
      $defaultLight,
      $noColor,
      $dracula,
      $nord,
      $gruvboxDark,
      $gruvboxLight,
      $catppuccinMocha,
      $catppuccinLatte,
      $tokyoNight,
      $solarizedDark,
      $solarizedLight
    ) + $additionalThemes) {
    $script:GlyThemes[$theme.Name] = $theme
  }
}
