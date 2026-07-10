Describe 'gly previews' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'
    Import-Module $modulePath -Force
  }

  It 'exports all preview commands' {
    $commands = Get-Command -Module gly | Select-Object -ExpandProperty Name
    $commands | Should -Contain 'Show-GlyThemeColor'
    $commands | Should -Contain 'Show-GlyGlyph'
    $commands | Should -Contain 'Show-GlyThemePreview'
  }

  It 'shows the default and every theme matcher' {
    $theme = Get-GlyTheme DefaultDark
    $rows = @(Show-GlyThemeColor -Theme DefaultDark)

    $rows.Count | Should -Be ($theme.Rules.Count + 1)
    $rows[0].Matcher | Should -Be 'Default'
    $rows[0].Color | Should -Match '#d4d4d4'
    $rows[0].Preview | Should -Match "`e\["
    $rows.Matcher | Should -Contain 'dir'
  }

  It 'shows the default and every glyph matcher' {
    $glyphSet = Get-GlyGlyphSet ANSI
    $rows = @(Show-GlyGlyph -GlyphSet ANSI)

    $rows.Count | Should -Be ($glyphSet.Rules.Count + 1)
    $rows[0].Glyph | Should -Be '[file]'
    ($rows | Where-Object Matcher -EQ 'dir').Glyph | Should -Be '[dir]'
  }

  It 'combines matching colors and glyphs without changing configuration' {
    $before = Get-GlyConfiguration
    $row = Show-GlyThemePreview -Theme DefaultDark -GlyphSet ANSI |
      Where-Object Matcher -EQ 'dir'

    $row.Glyph | Should -Be '[dir]'
    $row.Color | Should -Match '#8ec07c'
    $row.Preview | Should -Match '\[dir\] Sample'
    $row.Preview | Should -Match "`e\["
    (Get-GlyConfiguration).Theme | Should -Be $before.Theme
    (Get-GlyConfiguration).GlyphSet | Should -Be $before.GlyphSet
  }

  It 'uses the active selections by default' {
    Set-GlyTheme DefaultLight | Out-Null
    Set-GlyGlyphSet Unicode | Out-Null

    (Show-GlyThemeColor | Select-Object -First 1).Color | Should -Match '#24292f'
    (Show-GlyGlyph | Select-Object -First 1).Glyph | Should -Be '□'
  }

  It 'throws for unknown preview selections' {
    { Show-GlyThemeColor -Theme MissingTheme } | Should -Throw
    { Show-GlyGlyph -GlyphSet MissingGlyphSet } | Should -Throw
  }
}
