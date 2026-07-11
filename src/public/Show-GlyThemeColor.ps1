function Show-GlyThemeColor {
  [CmdletBinding(DefaultParameterSetName = 'Selected')]
  param(
    [Parameter(ParameterSetName = 'Selected', Position = 0)]
    [Alias('Name')]
    [string] $Theme = $script:GlyConfiguration.Theme,

    [Parameter(Mandatory, ParameterSetName = 'All')]
    [switch] $All
  )

  $selectedThemes = if ($All) {
    @(Get-GlyTheme)
  }
  else {
    @(Get-GlyTheme -Name $Theme)
  }

  $rows = foreach ($selectedTheme in $selectedThemes) {
    $styles = [ordered]@{}
    $entries = @(
      [pscustomobject]@{
        Matcher = 'Default'
        Sample  = ConvertTo-GlyPreviewName
        Style   = $selectedTheme.Default
      }

      foreach ($rule in $selectedTheme.Rules) {
        [pscustomobject]@{
          Matcher = ConvertTo-GlyMatcherLabel -Selector $rule.Selector
          Sample  = ConvertTo-GlyPreviewName -Selector $rule.Selector
          Style   = $rule.Style
        }
      }
    )

    foreach ($entry in $entries) {
      $style = $entry.Style
      $signature = @(
        $style.Foreground,
        $style.Background,
        $style.Bold,
        $style.Italic,
        $style.Underline
      ) -join '|'

      if ($styles.Contains($signature)) {
        $styles[$signature].Matchers += $entry.Matcher
        $styles[$signature].Samples += $entry.Sample
      }
      else {
        $styles[$signature] = [pscustomobject]@{
          Matchers = @($entry.Matcher)
          Samples  = @($entry.Sample)
          Style    = $style
        }
      }
    }

    foreach ($entry in $styles.Values) {
      [pscustomobject] [ordered]@{
        PSTypeName = 'gly.ThemeColorPreview'
        Theme      = $selectedTheme.Name
        Matcher    = $entry.Matchers -join ', '
        Color      = ConvertTo-GlyStyleLabel -Style $entry.Style
        Preview    = ConvertTo-GlyPreviewText -Text ($entry.Samples -join ', ') -Style $entry.Style
      }
    }
  }

  return $rows
}
