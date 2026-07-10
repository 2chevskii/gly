Describe 'gly theme gallery tape' {
  It 'covers every built-in theme exactly once with an explicit background' {
    $generatorPath = Join-Path $PSScriptRoot '../scripts/capture/New-GlyThemeGalleryTape.ps1'

    & $generatorPath -OutputDirectory $TestDrive

    $tapes = @(
      Get-Content -LiteralPath (Join-Path $TestDrive 'theme-gallery-dark.tape')
      Get-Content -LiteralPath (Join-Path $TestDrive 'theme-gallery-light.tape')
    )
    $screenshots = @($tapes | Where-Object { $_ -like 'Screenshot assets/captures/themes/*.png' })

    $screenshots.Count | Should -Be 90
    ($screenshots | Select-Object -Unique).Count | Should -Be 90
    ($tapes -contains 'Set Theme "Catppuccin Mocha"') | Should -Be $true
    ($tapes -contains 'Set Theme "Catppuccin Latte"') | Should -Be $true
  }

  It 'generates one glyph set capture and gallery entry for each built-in set' {
    $tapePath = Join-Path $TestDrive 'glyph-set-gallery.tape'
    $galleryPath = Join-Path $TestDrive 'captures.md'

    & (Join-Path $PSScriptRoot '../scripts/capture/New-GlyGlyphSetGalleryTape.ps1') -OutputPath $tapePath
    & (Join-Path $PSScriptRoot '../scripts/capture/New-GlyCaptureGalleryDocs.ps1') -OutputPath $galleryPath

    $tape = Get-Content -LiteralPath $tapePath
    $gallery = Get-Content -Raw -LiteralPath $galleryPath

    @($tape | Where-Object { $_ -like 'Screenshot assets/captures/glyph-sets/*.png' }).Count | Should -Be 5
    ([regex]::Matches($gallery, '<figure>')).Count | Should -Be 95
    ([regex]::Matches($gallery, 'theme preview with Nerd Fonts glyphs')).Count | Should -Be 90
    ([regex]::Matches($gallery, 'glyph set preview with the DefaultDark theme')).Count | Should -Be 5
  }
}
