Describe 'gly snapshots' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'
    $snapshotDirectory = Join-Path $PSScriptRoot 'snapshots'
    $fixtureDirectory = Join-Path $TestDrive 'snapshot-fixture'
    New-Item -ItemType Directory -Path $fixtureDirectory | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $fixtureDirectory 'src') | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $fixtureDirectory 'src/nested.txt'), '')
    [System.IO.File]::WriteAllBytes((Join-Path $fixtureDirectory 'README.md'), [byte[]]::new(1536))
    [System.IO.File]::WriteAllText((Join-Path $fixtureDirectory 'app.ps1'), '')

    foreach ($item in Get-ChildItem -LiteralPath $fixtureDirectory) {
      $item.LastWriteTime = [datetime]::new(2024, 1, 2, 3, 4, 0)
    }

    function Assert-GlySnapshot {
      param(
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)][AllowEmptyString()][string] $Actual
      )

      $path = Join-Path $snapshotDirectory "$Name.snap"
      $normalized = $Actual.Replace("`e", '<ESC>').Replace("`r`n", "`n").TrimEnd() + "`n"

      if ($env:GLY_UPDATE_SNAPSHOTS -eq '1') {
        [System.IO.File]::WriteAllText($path, $normalized, [System.Text.UTF8Encoding]::new($false))
      }

      Test-Path -LiteralPath $path | Should -BeTrue -Because "snapshot $Name must be committed"
      $expected = [System.IO.File]::ReadAllText($path).Replace("`r`n", "`n")
      $normalized | Should -BeExactly $expected
    }

  }

  BeforeEach {
    Import-Module $modulePath -Force
    Set-GlyConfiguration -ShowColors $false -ShowGlyphs $true -GlyphSet ANSI -StyleRenderer PlainText -DateFormat Iso | Out-Null
  }

  It 'captures the public command and alias surface' {
    $surface = [ordered]@{
      Commands = @(Get-Command -Module gly | Where-Object CommandType -EQ Function | Select-Object -ExpandProperty Name | Sort-Object)
      Aliases = @(@('gly', 'glytr', 'glygr') | ForEach-Object { "$_=$((Get-Alias $_).ResolvedCommandName)" })
    }

    Assert-GlySnapshot 'public-surface' (ConvertTo-Json -InputObject $surface -Depth 4)
  }

  It 'captures every built-in theme and its ordered rules' {
    $rows = foreach ($theme in Get-GlyTheme) {
      [ordered]@{
        Name = $theme.Name
        Default = $theme.Default.Foreground
        Rules = @($theme.Rules | ForEach-Object {
          [ordered]@{
            Kind = [string] $_.Selector.Kind
            Attributes = @($_.Selector.Attributes | ForEach-Object { [string] $_ })
            Foreground = $_.Style.Foreground
            Bold = $_.Style.Bold
          }
        })
      }
    }

    Assert-GlySnapshot 'themes' (ConvertTo-Json -InputObject @($rows) -Depth 8)
  }

  It 'captures every built-in glyph and selector' {
    $rows = foreach ($glyphSet in Get-GlyGlyphSet) {
      [ordered]@{
        Name = $glyphSet.Name
        Default = $glyphSet.Default
        Rules = @($glyphSet.Rules | ForEach-Object {
          [ordered]@{
            Kind = [string] $_.Selector.Kind
            Name = $_.Selector.Name
            Extension = @($_.Selector.Extension)
            Glob = @($_.Selector.Glob)
            Attributes = @($_.Selector.Attributes | ForEach-Object { [string] $_ })
            Glyph = $_.Glyph
          }
        })
      }
    }

    Assert-GlySnapshot 'glyphs' (ConvertTo-Json -InputObject @($rows) -Depth 8)
  }

  It 'captures color, glyph, and combined previews' {
    $rows = [ordered]@{
      Colors = @(Show-GlyThemeColor DefaultDark | Select-Object Theme, Matcher, Color, Preview)
      Glyphs = @(Show-GlyGlyph ANSI | Select-Object GlyphSet, Matcher, Glyph, Preview)
      Combined = @(Show-GlyThemePreview -Theme DefaultDark -GlyphSet ANSI | Select-Object Matcher, Glyph, Color, Preview)
    }

    Assert-GlySnapshot 'previews' (ConvertTo-Json -InputObject $rows -Depth 8)
  }

  It 'captures configuration and registry lifecycle' {
    $states = [ordered]@{}
    $states.Initial = Get-GlyConfiguration
    $theme = Register-GlyTheme (Copy-GlyTheme DefaultLight SnapshotTheme)
    $glyphSet = Register-GlyGlyphSet (Copy-GlyGlyphSet ANSICompact SnapshotGlyphs)
    $states.Registered = [ordered]@{
      Theme = "$($theme.Name):$($theme.BuiltIn):$($theme.Rules.Count)"
      GlyphSet = "$($glyphSet.Name):$($glyphSet.BuiltIn):$($glyphSet.Rules.Count)"
    }
    Set-GlyTheme SnapshotTheme | Out-Null
    Set-GlyGlyphSet SnapshotGlyphs | Out-Null
    Set-GlyConfiguration -SizeFormat Binary -DateFormat Iso -ResetAfterName $false | Out-Null
    $states.Configured = Get-GlyConfiguration
    Disable-Gly
    $states.Disabled = Get-GlyConfiguration
    Enable-Gly
    $states.Enabled = Get-GlyConfiguration

    Assert-GlySnapshot 'configuration' (ConvertTo-Json -InputObject $states -Depth 6)
  }

  It 'captures display names for file, directory, and project matchers' {
    $items = @(Get-ChildItem -LiteralPath $fixtureDirectory | Sort-Object Name)
    $rows = foreach ($glyphSet in @('ANSI', 'ANSICompact', 'Unicode', 'Emoji', 'NerdFonts')) {
      Set-GlyGlyphSet $glyphSet | Out-Null
      foreach ($item in $items) {
        [ordered]@{ GlyphSet = $glyphSet; File = $item.Name; Display = Get-GlyFileSystemDisplayName $item }
      }
    }

    Set-GlyGlyphSet ANSI | Out-Null
    Set-GlyConfiguration -ShowGlyphs $false | Out-Null
    $rows += [ordered]@{ GlyphSet = 'None'; File = 'README.md'; Display = Get-GlyFileSystemDisplayName (Get-Item (Join-Path $fixtureDirectory 'README.md')) }
    Assert-GlySnapshot 'display-names' (ConvertTo-Json -InputObject @($rows) -Depth 4)
  }

  It 'captures explicit renderers, size formats, and the standard view' {
    $items = @(Get-ChildItem -LiteralPath $fixtureDirectory | Sort-Object Name)
    $records = @(($items | Show-Gly) | Select-Object LastWriteTime, Length, Name)
    $tree = @(Get-Item (Join-Path $fixtureDirectory 'src') | Show-GlyTree -Depth 1)
    $grid = @(($items | Show-GlyGrid) | ForEach-Object { $_.TrimEnd() })

    Set-GlyConfiguration -SizeFormat Binary | Out-Null
    $binaryRecord = Get-Item (Join-Path $fixtureDirectory 'README.md') | Show-Gly |
      Select-Object LastWriteTime, Length, Name
    $formatted = Get-Item (Join-Path $fixtureDirectory 'README.md') | Format-Table | Out-String
    $standardView = [ordered]@{
      ViewName = @(Get-FormatData -TypeName System.IO.FileInfo).FormatViewDefinition[0].Name
      Headers = @('Mode', 'LastWriteTime', 'Length', 'Name' | Where-Object { $formatted.Contains($_) })
      BinarySize = $formatted.Contains('1.5 KiB')
      DisplayName = $formatted.Contains('[file] README.md')
    }

    $rows = [ordered]@{
      Records = $records
      Tree = $tree
      Grid = $grid
      BinaryRecord = $binaryRecord
      StandardView = $standardView
    }
    Assert-GlySnapshot 'renderers' (ConvertTo-Json -InputObject $rows -Depth 6)
  }

  It 'captures the literal output of <Command>' -ForEach @(
    @{ Command = 'get-item' }
    @{ Command = 'get-childitem' }
    @{ Command = 'show-gly' }
    @{ Command = 'show-glytree' }
    @{ Command = 'show-glygrid' }
  ) {
    $platform = if ($IsWindows) { 'windows' } elseif ($IsLinux) { 'linux' } else { throw 'No literal snapshot exists for this platform.' }
    $previousCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
    [System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')

    try {
      $items = @(Get-ChildItem -LiteralPath $fixtureDirectory | Sort-Object Name)
      $file = Get-Item (Join-Path $fixtureDirectory 'README.md')
      $directory = Get-Item (Join-Path $fixtureDirectory 'src')
      $output = switch ($Command) {
        'get-item' { $file | Out-String -Width 120 }
        'get-childitem' { $items | Out-String -Width 120 }
        'show-gly' { $items | Show-Gly | Out-String -Width 120 }
        'show-glytree' { $directory | Show-GlyTree -Depth 1 | Out-String -Width 120 }
        'show-glygrid' { $items | Show-GlyGrid | Out-String -Width 120 }
      }

      $literal = ConvertTo-Json -InputObject $output -Compress
      Assert-GlySnapshot "literal-$Command.$platform" $literal
    }
    finally {
      [System.Threading.Thread]::CurrentThread.CurrentCulture = $previousCulture
    }
  }

  It 'captures ANSI rendering and reset behavior' {
    $file = Get-Item (Join-Path $fixtureDirectory 'README.md')
    Set-GlyConfiguration -ShowColors $true -StyleRenderer Ansi -RespectNoColor $false | Out-Null
    $rows = [ordered]@{
      WithReset = Get-GlyFileSystemDisplayName $file
      WithoutReset = ''
      NoColorTheme = ''
    }
    Set-GlyConfiguration -ResetAfterName $false | Out-Null
    $rows.WithoutReset = Get-GlyFileSystemDisplayName $file
    Set-GlyTheme NoColor | Out-Null
    $rows.NoColorTheme = Get-GlyFileSystemDisplayName $file

    Assert-GlySnapshot 'ansi' (ConvertTo-Json -InputObject $rows -Depth 4)
  }

  It 'captures user rules, precedence, and validation errors' {
    $theme = @{
      Name = 'SnapshotRuleTheme'
      Default = @{ Foreground = '#111111' }
      Rules = @(
        @{ Selector = @{ Extension = '.ps1' }; Style = @{ Foreground = '#abcdef' } }
        @{ Selector = @{ Name = 'app.ps1' }; Style = @{ Foreground = '#fedcba' } }
      )
    }
    $glyphSet = @{
      Name = 'SnapshotRuleGlyphs'
      Default = '?'
      Rules = @(
        @{ Selector = @{ Extension = '.ps1' }; Glyph = 'extension' }
        @{ Selector = @{ Name = 'app.ps1' }; Glyph = 'name' }
      )
    }
    Register-GlyTheme $theme | Out-Null
    Register-GlyGlyphSet $glyphSet | Out-Null
    Set-GlyTheme SnapshotRuleTheme | Out-Null
    Set-GlyGlyphSet SnapshotRuleGlyphs | Out-Null
    Set-GlyConfiguration -ShowColors $true -StyleRenderer Ansi -RespectNoColor $false | Out-Null

    $rows = [ordered]@{
      Matching = Get-GlyFileSystemDisplayName (Get-Item (Join-Path $fixtureDirectory 'app.ps1'))
      Fallback = Get-GlyFileSystemDisplayName (Get-Item (Join-Path $fixtureDirectory 'README.md'))
      GlyphRules = @((Get-GlyGlyphSet SnapshotRuleGlyphs).Rules | ForEach-Object { $_.Glyph })
      UnknownTheme = ''
      UnknownGlyphSet = ''
    }
    try { Set-GlyTheme MissingTheme -ErrorAction Stop | Out-Null } catch { $rows.UnknownTheme = $_.Exception.Message }
    try { Set-GlyGlyphSet MissingGlyphSet -ErrorAction Stop | Out-Null } catch { $rows.UnknownGlyphSet = $_.Exception.Message }

    Assert-GlySnapshot 'user-rules' (ConvertTo-Json -InputObject $rows -Depth 5)
  }
}
