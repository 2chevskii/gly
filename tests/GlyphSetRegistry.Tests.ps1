$modulePath = Join-Path $PSScriptRoot '../src/gly/gly.psd1'

Describe 'gly glyph set registry' {
    Import-Module $modulePath -Force

    It 'lists built-in glyph sets' {
        $names = Get-GlyGlyphSet | Select-Object -ExpandProperty Name
        ($names -contains 'NerdFonts') | Should Be $true
        ($names -contains 'ANSI') | Should Be $true
        ($names -contains 'ANSICompact') | Should Be $true
        ($names -contains 'Unicode') | Should Be $true
        ($names -contains 'Emoji') | Should Be $true
    }

    It 'does not allow overwriting a built-in glyph set' {
        $glyphSet = @{
            Name = 'NerdFonts'
            Default = '?'
            Rules = @()
        }
        $thrown = $false
        try { Register-GlyGlyphSet -GlyphSet $glyphSet } catch { $thrown = $true }
        $thrown | Should Be $true
    }

    It 'copies and registers a user glyph set' {
        $copy = Copy-GlyGlyphSet -Name ANSI -NewName UserGlyphs
        $registered = Register-GlyGlyphSet -GlyphSet $copy
        $registered.Name | Should Be 'UserGlyphs'
        $registered.BuiltIn | Should Be $false
        Set-GlyGlyphSet UserGlyphs | Out-Null
        (Get-GlyConfiguration).GlyphSet | Should Be 'UserGlyphs'
    }

    It 'throws for unknown glyph set selection' {
        $thrown = $false
        try { Set-GlyGlyphSet MissingGlyphSet } catch { $thrown = $true }
        $thrown | Should Be $true
    }
}
