Describe 'gly theme registry' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'
    Import-Module $modulePath -Force
  }

  It 'lists built-in themes' {
    $names = Get-GlyTheme | Select-Object -ExpandProperty Name
    $expectedNames = @(
      'DefaultDark',
      'DefaultLight',
      'NoColor',
      'Dracula',
      'Nord',
      'GruvboxDark',
      'GruvboxLight',
      'CatppuccinMocha',
      'CatppuccinLatte',
      'TokyoNight',
      'SolarizedDark',
      'SolarizedLight',
      'CatppuccinFrappe',
      'CatppuccinMacchiato',
      'RosePine',
      'RosePineMoon',
      'RosePineDawn',
      'TokyoNightStorm',
      'TokyoNightMoon',
      'TokyoNightDay',
      'KanagawaWave',
      'KanagawaDragon',
      'KanagawaLotus',
      'EverforestDark',
      'EverforestLight',
      'OneDark',
      'OneLight',
      'OneDarkPro',
      'GitHubDark',
      'GitHubLight',
      'GitHubDimmed',
      'GitHubHighContrast',
      'VSCodeDarkPlus',
      'VSCodeLightPlus',
      'VSCodeHighContrast',
      'JetBrainsDarcula',
      'Monokai',
      'MonokaiPro',
      'Molokai',
      'MaterialDark',
      'MaterialLight',
      'MaterialPalenight',
      'MaterialOcean',
      'Palenight',
      'AyuDark',
      'AyuLight',
      'AyuMirage',
      'NightOwl',
      'LightOwl',
      'Cobalt2',
      'SynthWave84',
      'ShadesOfPurple',
      'Horizon',
      'Omni',
      'NoctisDark',
      'NoctisLight',
      'Andromeda',
      'Aura',
      'EvaDark',
      'EvaLight',
      'CityLights',
      'Jellybeans',
      'PaperColorDark',
      'PaperColorLight',
      'OceanicNext',
      'Sonokai',
      'EdgeDark',
      'EdgeLight',
      'Nightfox',
      'Dayfox',
      'Dawnfox',
      'Nordfox',
      'Carbonfox',
      'FlexokiDark',
      'FlexokiLight',
      'SerendipityDark',
      'SerendipityLight',
      'IcebergDark',
      'IcebergLight',
      'Srcery',
      'Apprentice',
      'Deus',
      'VitesseDark',
      'VitesseLight',
      'Poimandres',
      'Spacegray',
      'Gotham',
      'Flatland',
      'ParaisoDark',
      'ParaisoLight'
    )

    foreach ($expectedName in $expectedNames) {
      ($names -contains $expectedName) | Should -Be $true
    }
  }

  It 'does not allow overwriting a built-in theme' {
    $theme = @{
      Name    = 'DefaultDark'
      Default = @{ Foreground = $null; Background = $null; Bold = $false; Italic = $false; Underline = $false }
      Rules   = @()
    }
    $thrown = $false
    try { Register-GlyTheme -Theme $theme } catch { $thrown = $true }
    $thrown | Should -Be $true
  }

  It 'returns strongly typed themes, rules, styles, and selectors' {
    $theme = Get-GlyTheme DefaultDark
    $theme.GetType().Name | Should -Be 'GlyTheme'
    $theme.Default.GetType().Name | Should -Be 'GlyStyle'
    $theme.Rules[0].GetType().Name | Should -Be 'GlyThemeRule'
    $theme.Rules[0].Selector.GetType().Name | Should -Be 'GlySelector'
    $theme.Rules.Count | Should -BeGreaterThan 50
  }

  It 'copies and registers a user theme' {
    $copy = Copy-GlyTheme -Name DefaultDark -NewName UserDark
    $registered = Register-GlyTheme -Theme $copy
    $registered.Name | Should -Be 'UserDark'
    $registered.BuiltIn | Should -Be $false
    Set-GlyTheme UserDark | Out-Null
    (Get-GlyConfiguration).Theme | Should -Be 'UserDark'
  }

  It 'throws for unknown theme selection' {
    $thrown = $false
    try { Set-GlyTheme MissingTheme } catch { $thrown = $true }
    $thrown | Should -Be $true
  }

  It 'does not expose mutable built-in registry instances' {
    $copy = Get-GlyTheme DefaultDark
    $copy.Name = 'ChangedOutsideRegistry'
    (Get-GlyTheme DefaultDark).Name | Should -Be 'DefaultDark'
  }
}
