Describe 'gly dynamic name completion' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'
  }

  BeforeEach {
    Import-Module $modulePath -Force
  }

  It 'completes built-in theme names for named and positional selection' {
    $namedLine = 'Set-GlyTheme -Name Def'
    $positionalLine = 'Set-GlyTheme Def'
    $namedMatches = (TabExpansion2 -inputScript $namedLine -cursorColumn $namedLine.Length).CompletionMatches
    $positionalMatches = (TabExpansion2 -inputScript $positionalLine -cursorColumn $positionalLine.Length).CompletionMatches

    ($namedMatches.ListItemText -contains 'DefaultDark') | Should -Be $true
    ($positionalMatches.ListItemText -contains 'DefaultDark') | Should -Be $true
  }

  It 'completes built-in glyph set names' {
    $line = 'Set-GlyGlyphSet -Name U'
    $matches = (TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches

    ($matches.ListItemText -contains 'Unicode') | Should -Be $true
  }

  It 'uses the corresponding registry for configuration names' {
    $themeLine = 'Set-GlyConfiguration -Theme Cat'
    $glyphSetLine = 'Set-GlyConfiguration -GlyphSet A'
    $themeMatches = (TabExpansion2 -inputScript $themeLine -cursorColumn $themeLine.Length).CompletionMatches
    $glyphSetMatches = (TabExpansion2 -inputScript $glyphSetLine -cursorColumn $glyphSetLine.Length).CompletionMatches

    ($themeMatches.ListItemText -contains 'CatppuccinMocha') | Should -Be $true
    ($glyphSetMatches.ListItemText -contains 'ANSI') | Should -Be $true
    ($glyphSetMatches.ListItemText -contains 'CatppuccinMocha') | Should -Be $false
  }

  It 'reflects registered themes and glyph sets without reimporting' {
    Copy-GlyTheme -Name DefaultDark -NewName CompletionTheme | Register-GlyTheme | Out-Null
    Copy-GlyGlyphSet -Name ANSI -NewName CompletionGlyphs | Register-GlyGlyphSet | Out-Null

    $themeLine = 'Set-GlyTheme -Name Completion'
    $glyphSetLine = 'Set-GlyGlyphSet -Name Completion'
    $themeMatches = (TabExpansion2 -inputScript $themeLine -cursorColumn $themeLine.Length).CompletionMatches
    $glyphSetMatches = (TabExpansion2 -inputScript $glyphSetLine -cursorColumn $glyphSetLine.Length).CompletionMatches

    ($themeMatches.ListItemText -contains 'CompletionTheme') | Should -Be $true
    ($glyphSetMatches.ListItemText -contains 'CompletionGlyphs') | Should -Be $true
  }

  It 'filters literal prefixes and returns rich completion results' {
    $literalLine = 'Set-GlyTheme -Name ['
    $builtInLine = 'Set-GlyTheme -Name Def'
    $matches = (TabExpansion2 -inputScript $literalLine -cursorColumn $literalLine.Length).CompletionMatches
    $builtInMatch = (TabExpansion2 -inputScript $builtInLine -cursorColumn $builtInLine.Length).CompletionMatches |
      Where-Object ListItemText -EQ DefaultDark |
      Select-Object -First 1

    $matches.Count | Should -Be 0
    $builtInMatch.ResultType | Should -Be ([System.Management.Automation.CompletionResultType]::ParameterValue)
    $builtInMatch.ToolTip | Should -Be 'Built-in gly theme'
  }

  It 'quotes registered names containing spaces and apostrophes' {
    Copy-GlyTheme -Name DefaultDark -NewName "O'Brien Theme" | Register-GlyTheme | Out-Null

    $singleQuoteLine = "Set-GlyTheme -Name 'O"
    $match = (TabExpansion2 -inputScript $singleQuoteLine -cursorColumn $singleQuoteLine.Length).CompletionMatches |
      Where-Object ListItemText -EQ "O'Brien Theme" |
      Select-Object -First 1

    $match.CompletionText | Should -Be "'O''Brien Theme'"
    $match.ListItemText | Should -Be "O'Brien Theme"
    $match.ToolTip | Should -Be 'Registered gly theme'
  }

  It 'keeps command validation authoritative' {
    { Set-GlyTheme MissingTheme } | Should -Throw "Unknown gly theme 'MissingTheme'.*"
  }

  It 'replaces completers when the module is reimported' {
    Copy-GlyTheme -Name DefaultDark -NewName OldCompletionTheme | Register-GlyTheme | Out-Null
    $line = 'Set-GlyTheme -Name OldCompletion'
    ((TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches).Count | Should -Be 1

    Import-Module $modulePath -Force

    ((TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches).Count | Should -Be 0
  }

  It 'does not return stale results after module removal' {
    Remove-Module gly -Force
    function global:Set-GlyTheme {
      param([string] $Name)
    }

    try {
      $line = 'Set-GlyTheme -Name Def'
      ((TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches).Count | Should -Be 0
    }
    finally {
      Remove-Item function:global:Set-GlyTheme -ErrorAction SilentlyContinue
    }
  }
}
