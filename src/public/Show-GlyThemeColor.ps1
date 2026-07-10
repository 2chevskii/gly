function Show-GlyThemeColor {
  [CmdletBinding()]
  param(
    [Alias('Name')]
    [string] $Theme = $script:GlyConfiguration.Theme
  )

  $selectedTheme = Get-GlyTheme -Name $Theme
  $rows = @(
    [pscustomobject] [ordered]@{
      PSTypeName = 'gly.ThemeColorPreview'
      Matcher    = 'Default'
      Color      = ConvertTo-GlyStyleLabel -Style $selectedTheme.Default
      Preview    = ConvertTo-GlyPreviewText -Text 'Sample' -Style $selectedTheme.Default
    }

    foreach ($rule in $selectedTheme.Rules) {
      [pscustomobject] [ordered]@{
        PSTypeName = 'gly.ThemeColorPreview'
        Matcher    = ConvertTo-GlyMatcherLabel -Selector $rule.Selector
        Color      = ConvertTo-GlyStyleLabel -Style $rule.Style
        Preview    = ConvertTo-GlyPreviewText -Text 'Sample' -Style $rule.Style
      }
    }
  )

  return $rows
}
