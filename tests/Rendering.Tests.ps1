Describe 'gly rendering' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'

    $root = Join-Path $TestDrive 'rendering'
    New-Item -ItemType Directory -Path $root | Out-Null
    $file = New-Item -ItemType File -Path (Join-Path $root 'README.md')

    Import-Module $modulePath -Force
    Set-GlyGlyphSet ANSICompact | Out-Null
    Set-GlyConfiguration -ShowColors $false -StyleRenderer PlainText | Out-Null
  }

  It 'disables glyphs through configuration' {
    Set-GlyConfiguration -ShowGlyphs $false | Out-Null
    Get-GlyFileSystemDisplayName -InputObject $file | Should -Be 'README.md'
    Set-GlyConfiguration -ShowGlyphs $true | Out-Null
  }

  It 'disables colors through configuration' {
    Set-GlyConfiguration -ShowColors $false | Out-Null
    Get-GlyFileSystemDisplayName -InputObject $file | Should -Not -Match "`e\[[0-9;]*m"
  }

  It 'uses NO_COLOR when requested' {
    $env:NO_COLOR = '1'
    Set-GlyConfiguration -ShowColors $true -RespectNoColor $true | Out-Null
    Get-GlyFileSystemDisplayName -InputObject $file | Should -Not -Match "`e\[[0-9;]*m"
    Remove-Item Env:NO_COLOR
  }

  It 'reacts to global renderer overrides without stale cached output' {
    Set-GlyConfiguration -ShowColors $true -StyleRenderer Ansi | Out-Null
    Get-GlyFileSystemDisplayName -InputObject $file | Should -Match "`e\[[0-9;]*m"
    $global:GlyStyleRenderer = 'PlainText'
    Get-GlyFileSystemDisplayName -InputObject $file | Should -Not -Match "`e\[[0-9;]*m"
    Remove-Variable GlyStyleRenderer -Scope Global
    Get-GlyFileSystemDisplayName -InputObject $file | Should -Match "`e\[[0-9;]*m"
    Set-GlyConfiguration -ShowColors $false -StyleRenderer PlainText | Out-Null
  }

  It 'Show-Gly accepts pipeline input' {
    $record = Get-Item -LiteralPath $file.FullName | Show-Gly
    $record.Name | Should -Match 'README\.md'
  }

  It 'Show-Gly accepts Path and LiteralPath' {
    (Show-Gly -Path $root | Select-Object -First 1).Name | Should -Match 'README\.md'
    (Show-Gly -LiteralPath $root | Select-Object -First 1).Name | Should -Match 'README\.md'
  }

  It 'Show-GlyTree renders branch markers' {
    $tree = Get-Item -LiteralPath $root | Show-GlyTree -Depth 1
    ($tree -join "`n") | Should -Match '\+-- .*README\.md'
  }

  It 'format data bridge is active for Get-Item' {
    $text = Get-Item -LiteralPath $file.FullName | Format-Table | Out-String
    $text | Should -Match 'README\.md'
  }

  It 'formats sizes in the standard file-system view' {
    [System.IO.File]::WriteAllBytes($file.FullName, [byte[]]::new(1536))
    Set-GlyConfiguration -SizeFormat Raw | Out-Null

    $rawText = Get-ChildItem -LiteralPath $root | Format-Table | Out-String

    $rawText | Should -Match '1536'

    Set-GlyConfiguration -SizeFormat Binary | Out-Null

    $binaryText = Get-ChildItem -LiteralPath $root | Format-Table | Out-String

    $binaryText | Should -Match '1\.5 KiB'
  }
}

Describe 'gly built-in theme precedence' {
  BeforeAll {
    $root = Join-Path $TestDrive 'theme-precedence'
    New-Item -ItemType Directory -Path $root | Out-Null
    $directory = New-Item -ItemType Directory -Path (Join-Path $root 'source')
    $readOnlyFile = New-Item -ItemType File -Path (Join-Path $root 'read-only.txt')
    $readOnlyFile.Attributes = $readOnlyFile.Attributes -bor [System.IO.FileAttributes]::ReadOnly
    $hiddenReadOnlyFile = New-Item -ItemType File -Path (Join-Path $root 'hidden-read-only.txt')
    $hiddenReadOnlyFile.Attributes = $hiddenReadOnlyFile.Attributes -bor
      [System.IO.FileAttributes]::ReadOnly -bor [System.IO.FileAttributes]::Hidden
    $regularFile = New-Item -ItemType File -Path (Join-Path $root 'ordinary.txt')

    Import-Module (Join-Path $PSScriptRoot '../src/gly.psd1') -Force
    Set-GlyTheme DefaultDark | Out-Null
    Set-GlyConfiguration -ShowGlyphs $false -ShowColors $true -StyleRenderer Ansi -RespectNoColor $false | Out-Null
  }

  It 'uses the file color for an ordinary file' {
    Get-GlyFileSystemDisplayName -InputObject $regularFile | Should -Match "`e\[38;2;212;212;212m"
  }

  It 'uses the directory color and bold style' {
    Get-GlyFileSystemDisplayName -InputObject $directory | Should -Match "`e\[1;38;2;142;192;124m"
  }

  It 'uses the read-only color' {
    Get-GlyFileSystemDisplayName -InputObject $readOnlyFile | Should -Match "`e\[38;2;250;189;47m"
  }

  It 'gives hidden precedence over read-only' {
    Get-GlyFileSystemDisplayName -InputObject $hiddenReadOnlyFile | Should -Match "`e\[38;2;146;131;116m"
  }

  It 'keeps glyphs in plain-text mode without color escapes' {
    Set-GlyConfiguration -ShowGlyphs $true -StyleRenderer PlainText | Out-Null
    $name = Get-GlyFileSystemDisplayName -InputObject $regularFile
    $name | Should -Match 'ordinary\.txt$'
    $name | Should -Not -Match "`e\["
  }
}
