function Initialize-GlyThemes {
  $script:GlyThemes = [ordered]@{}

  $defaultDark = [ordered]@{
    Name    = 'DefaultDark'
    BuiltIn = $true
    Default = [ordered]@{ Foreground = '#d4d4d4'; Background = $null; Bold = $false; Italic = $false; Underline = $false }
    Rules   = @(
      [ordered]@{ Selector = [ordered]@{ Kind = 'File' }; Style = [ordered]@{ Foreground = '#d4d4d4'; Background = $null; Bold = $false; Italic = $false; Underline = $false } },
      [ordered]@{ Selector = [ordered]@{ Kind = 'Directory' }; Style = [ordered]@{ Foreground = '#8ec07c'; Background = $null; Bold = $true; Italic = $false; Underline = $false } },
      [ordered]@{ Selector = [ordered]@{ Kind = 'Symlink' }; Style = [ordered]@{ Foreground = '#83a598'; Background = $null; Bold = $false; Italic = $false; Underline = $false } },
      [ordered]@{ Selector = [ordered]@{ Attributes = @('Hidden') }; Style = [ordered]@{ Foreground = '#928374'; Background = $null; Bold = $false; Italic = $false; Underline = $false } },
      [ordered]@{ Selector = [ordered]@{ Attributes = @('ReadOnly') }; Style = [ordered]@{ Foreground = '#fabd2f'; Background = $null; Bold = $false; Italic = $false; Underline = $false } },
      [ordered]@{ Selector = [ordered]@{ Extension = '.ps1' }; Style = [ordered]@{ Foreground = '#83a598'; Background = $null; Bold = $false; Italic = $false; Underline = $false } },
      [ordered]@{ Selector = [ordered]@{ Extension = '.json' }; Style = [ordered]@{ Foreground = '#d3869b'; Background = $null; Bold = $false; Italic = $false; Underline = $false } },
      [ordered]@{ Selector = [ordered]@{ Extension = '.md' }; Style = [ordered]@{ Foreground = '#b8bb26'; Background = $null; Bold = $false; Italic = $false; Underline = $false } }
    )
  }

  $defaultLight = Copy-GlyObject -InputObject $defaultDark
  $defaultLight.Name = 'DefaultLight'
  $defaultLight.Default.Foreground = '#24292f'
  $defaultLight.Rules[0].Style.Foreground = '#24292f'
  $defaultLight.Rules[1].Style.Foreground = '#0969da'
  $defaultLight.Rules[2].Style.Foreground = '#8250df'
  $defaultLight.Rules[3].Style.Foreground = '#6e7781'
  $defaultLight.Rules[4].Style.Foreground = '#9a6700'
  $defaultLight.Rules[5].Style.Foreground = '#0550ae'
  $defaultLight.Rules[6].Style.Foreground = '#953800'
  $defaultLight.Rules[7].Style.Foreground = '#116329'

  $noColor = [ordered]@{
    Name    = 'NoColor'
    BuiltIn = $true
    Default = [ordered]@{ Foreground = $null; Background = $null; Bold = $false; Italic = $false; Underline = $false }
    Rules   = @()
  }

  foreach ($theme in @($defaultDark, $defaultLight, $noColor)) {
    $script:GlyThemes[$theme.Name] = $theme
  }
}
