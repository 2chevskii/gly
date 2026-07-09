$modulePath = Join-Path $PSScriptRoot '../src/gly/gly.psd1'

Describe 'gly rendering' {
  $root = Join-Path $TestDrive 'rendering'
  New-Item -ItemType Directory -Path $root | Out-Null
  $file = New-Item -ItemType File -Path (Join-Path $root 'README.md')

  Import-Module $modulePath -Force
  Set-GlyGlyphSet ANSICompact | Out-Null
  Set-GlyConfiguration -ShowColors $false -StyleRenderer PlainText | Out-Null

  It 'disables glyphs through configuration' {
    Set-GlyConfiguration -ShowGlyphs $false | Out-Null
    Get-GlyFileSystemDisplayName -InputObject $file | Should Be 'README.md'
    Set-GlyConfiguration -ShowGlyphs $true | Out-Null
  }

  It 'disables colors through configuration' {
    Set-GlyConfiguration -ShowColors $false | Out-Null
    Get-GlyFileSystemDisplayName -InputObject $file | Should Not Match "`e\[[0-9;]*m"
  }

  It 'uses NO_COLOR when requested' {
    $env:NO_COLOR = '1'
    Set-GlyConfiguration -ShowColors $true -RespectNoColor $true | Out-Null
    Get-GlyFileSystemDisplayName -InputObject $file | Should Not Match "`e\[[0-9;]*m"
    Remove-Item Env:NO_COLOR
  }

  It 'Show-Gly accepts pipeline input' {
    $record = Get-Item -LiteralPath $file.FullName | Show-Gly
    $record.Name | Should Match 'README\.md'
  }

  It 'Show-Gly accepts Path and LiteralPath' {
    (Show-Gly -Path $root | Select-Object -First 1).Name | Should Match 'README\.md'
    (Show-Gly -LiteralPath $root | Select-Object -First 1).Name | Should Match 'README\.md'
  }

  It 'Show-GlyTree renders branch markers' {
    $tree = Get-Item -LiteralPath $root | Show-GlyTree -Depth 1
    ($tree -join "`n") | Should Match '\+-- .*README\.md'
  }

  It 'format data bridge is active for Get-Item' {
    $text = Get-Item -LiteralPath $file.FullName | Format-Table | Out-String
    $text | Should Match 'README\.md'
  }
}
