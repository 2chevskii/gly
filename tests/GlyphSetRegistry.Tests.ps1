Describe 'gly glyph set registry' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'
    Import-Module $modulePath -Force
  }

  It 'lists built-in glyph sets' {
    $names = Get-GlyGlyphSet | Select-Object -ExpandProperty Name
    ($names -contains 'NerdFonts') | Should -Be $true
    ($names -contains 'ANSI') | Should -Be $true
    ($names -contains 'ANSICompact') | Should -Be $true
    ($names -contains 'Unicode') | Should -Be $true
    ($names -contains 'Emoji') | Should -Be $true
  }

  It 'returns strongly typed glyph sets, rules, and selectors' {
    $glyphSet = Get-GlyGlyphSet ANSI
    $glyphSet.GetType().Name | Should -Be 'GlyGlyphSet'
    $glyphSet.Rules[0].GetType().Name | Should -Be 'GlyGlyphRule'
    $glyphSet.Rules[0].Selector.GetType().Name | Should -Be 'GlySelector'
    $glyphSet.Rules.Count | Should -BeGreaterThan 50
  }

  It 'does not allow overwriting a built-in glyph set' {
    $glyphSet = @{
      Name    = 'NerdFonts'
      Default = '?'
      Rules   = @()
    }
    $thrown = $false
    try { Register-GlyGlyphSet -GlyphSet $glyphSet } catch { $thrown = $true }
    $thrown | Should -Be $true
  }

  It 'copies and registers a user glyph set' {
    $copy = Copy-GlyGlyphSet -name ANSI -NewName UserGlyphs
    $registered = Register-GlyGlyphSet -GlyphSet $copy
    $registered.Name | Should -Be 'UserGlyphs'
    $registered.BuiltIn | Should -Be $false
    Set-GlyGlyphSet UserGlyphs | Out-Null
    (Get-GlyConfiguration).GlyphSet | Should -Be 'UserGlyphs'
  }

  It 'throws for unknown glyph set selection' {
    $thrown = $false
    try { Set-GlyGlyphSet MissingGlyphSet } catch { $thrown = $true }
    $thrown | Should -Be $true
  }

  It 'rejects invalid selector kinds during registration' {
    $glyphSet = @{
      Name = 'InvalidSelectorGlyphs'
      Default = '?'
      Rules = @(@{ Selector = @{ Kind = 'file' }; Glyph = 'x' })
    }
    { Register-GlyGlyphSet -GlyphSet $glyphSet } | Should -Throw
  }
}
