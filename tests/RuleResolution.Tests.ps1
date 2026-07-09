$modulePath = Join-Path $PSScriptRoot '../src/gly/gly.psd1'

Describe 'gly rule resolution through glyph sets' {
    $root = Join-Path $TestDrive 'rules'
    New-Item -ItemType Directory -Path $root | Out-Null
    $psFile = New-Item -ItemType File -Path (Join-Path $root 'build.ps1')
    $compoundFile = New-Item -ItemType File -Path (Join-Path $root 'types.d.ts')
    $plainFile = New-Item -ItemType File -Path (Join-Path $root 'plain.unknown')
    $directory = New-Item -ItemType Directory -Path (Join-Path $root 'src')

    Import-Module $modulePath -Force
    Set-GlyConfiguration -ShowColors $false -StyleRenderer PlainText | Out-Null
    Set-GlyGlyphSet ANSI | Out-Null

    It 'selects glyph by normal extension' {
        Get-GlyFileSystemDisplayName -InputObject $psFile | Should Match '^\[ps\] build\.ps1$'
    }

    It 'selects glyph by compound extension before normal extension' {
        Get-GlyFileSystemDisplayName -InputObject $compoundFile | Should Match '^\[d\.ts\] types\.d\.ts$'
    }

    It 'falls back to default glyph for unknown files' {
        Get-GlyFileSystemDisplayName -InputObject $plainFile | Should Match '^\[file\] plain\.unknown$'
    }

    It 'uses a separate directory glyph' {
        Get-GlyFileSystemDisplayName -InputObject $directory | Should Match '^\[dir\] src$'
    }

    It 'later matching rule wins over earlier matching rule' {
        $glyphSet = @{
            Name = 'RuleOrderTest'
            Default = '?'
            Rules = @(
                @{ Selector = @{ Extension = '.txt' }; Glyph = 'early' },
                @{ Selector = @{ Extension = '.txt' }; Glyph = 'late' }
            )
        }
        Register-GlyGlyphSet -GlyphSet $glyphSet | Out-Null
        Set-GlyGlyphSet RuleOrderTest | Out-Null
        $file = New-Item -ItemType File -Path (Join-Path $root 'order.txt')
        Get-GlyFileSystemDisplayName -InputObject $file | Should Be 'late order.txt'
    }
}
