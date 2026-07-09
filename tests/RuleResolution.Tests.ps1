Describe 'gly rule resolution through glyph sets' {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'

    $root = Join-Path $TestDrive 'rules'
    New-Item -ItemType Directory -Path $root | Out-Null
    $psFile = New-Item -ItemType File -Path (Join-Path $root 'build.ps1')
    $compoundFile = New-Item -ItemType File -Path (Join-Path $root 'types.d.ts')
    $plainFile = New-Item -ItemType File -Path (Join-Path $root 'plain.unknown')
    $packageFile = New-Item -ItemType File -Path (Join-Path $root 'package.json')
    $imageFile = New-Item -ItemType File -Path (Join-Path $root 'logo.png')
    $dockerFile = New-Item -ItemType File -Path (Join-Path $root 'Dockerfile.dev')
    $hiddenPsFile = New-Item -ItemType File -Path (Join-Path $root 'hidden.ps1')
    $hiddenPsFile.Attributes = $hiddenPsFile.Attributes -bor [System.IO.FileAttributes]::Hidden
    $directory = New-Item -ItemType Directory -Path (Join-Path $root 'src')

    Import-Module $modulePath -Force
    Set-GlyConfiguration -ShowColors $false -StyleRenderer PlainText | Out-Null
    Set-GlyGlyphSet ANSI | Out-Null
  }

  It 'selects glyph by normal extension' {
    Get-GlyFileSystemDisplayName -InputObject $psFile | Should -Match '^\[ps\] build\.ps1$'
  }

  It 'selects glyph by compound extension before normal extension' {
    Get-GlyFileSystemDisplayName -InputObject $compoundFile | Should -Match '^\[d\.ts\] types\.d\.ts$'
  }

  It 'falls back to default glyph for unknown files' {
    Get-GlyFileSystemDisplayName -InputObject $plainFile | Should -Match '^\[file\] plain\.unknown$'
  }

  It 'uses a well-known source directory glyph' {
    Get-GlyFileSystemDisplayName -InputObject $directory | Should -Match '^\[src\] src$'
  }

  It 'selects glyph for a well-known package file before its extension' {
    Get-GlyFileSystemDisplayName -InputObject $packageFile | Should -Match '^\[package\] package\.json$'
  }

  It 'selects glyph for an expanded media extension' {
    Get-GlyFileSystemDisplayName -InputObject $imageFile | Should -Match '^\[image\] logo\.png$'
  }

  It 'selects glyph by wildcard file name' {
    Get-GlyFileSystemDisplayName -InputObject $dockerFile | Should -Match '^\[docker\] Dockerfile\.dev$'
  }

  It 'preserves last-match precedence across selector categories' {
    Get-GlyFileSystemDisplayName -InputObject $hiddenPsFile | Should -Match '^\[hidden\] hidden\.ps1$'
  }

  It 'later matching rule wins over earlier matching rule' {
    $glyphSet = @{
      Name    = 'RuleOrderTest'
      Default = '?'
      Rules   = @(
        @{ Selector = @{ Extension = '.txt' }; Glyph = 'early' },
        @{ Selector = @{ Extension = '.txt' }; Glyph = 'late' }
      )
    }
    Register-GlyGlyphSet -GlyphSet $glyphSet | Out-Null
    Set-GlyGlyphSet RuleOrderTest | Out-Null
    $file = New-Item -ItemType File -Path (Join-Path $root 'order.txt')
    Get-GlyFileSystemDisplayName -InputObject $file | Should -Be 'late order.txt'
  }
}
