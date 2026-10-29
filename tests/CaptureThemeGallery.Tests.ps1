Describe 'gly theme gallery tape' {
  It 'writes relative outputs in the current PowerShell location' {
    $captureScripts = Join-Path $PSScriptRoot '../scripts/capture'
    Push-Location $TestDrive
    try {
      & (Join-Path $captureScripts 'New-GlyThemeGalleryTape.ps1') -OutputDirectory 'tapes'
      & (Join-Path $captureScripts 'New-GlyGlyphSetGalleryTape.ps1') -OutputPath 'glyphs.tape'
      & (Join-Path $captureScripts 'New-GlyCaptureGalleryDocs.ps1') -OutputPath 'captures.md'

      Join-Path $TestDrive 'tapes/theme-gallery-dark.tape' | Should -Exist
      Join-Path $TestDrive 'tapes/theme-gallery-light.tape' | Should -Exist
      Join-Path $TestDrive 'glyphs.tape' | Should -Exist
      Join-Path $TestDrive 'captures.md' | Should -Exist
    }
    finally {
      Pop-Location
    }
  }

  It 'keeps the published gallery in sync with the registry and existing media' {
    $galleryPath = Join-Path $TestDrive 'captures.md'
    & (Join-Path $PSScriptRoot '../scripts/capture/New-GlyCaptureGalleryDocs.ps1') -OutputPath $galleryPath
    $gallery = (Get-Content -Raw -LiteralPath $galleryPath) -replace '\r\n', "`n"
    $committed = (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot '../docs/guide/captures.md')) -replace '\r\n', "`n"
    $gallery | Should -BeExactly $committed

    foreach ($match in [regex]::Matches($gallery, "/captures/[^']+")) {
      Join-Path $PSScriptRoot "../assets$($match.Value)" | Should -Exist
    }
    $gallery | Should -Match '<a :href="withBase\(''/captures/overview.png''\)">'
  }

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
    ($tapes | Where-Object { $_ -like 'Wait+Screen /Theme: */' }).Count | Should -Be 90
  }

  It 'generates one glyph set capture and gallery entry for each built-in set' {
    $tapePath = Join-Path $TestDrive 'glyph-set-gallery.tape'
    $galleryPath = Join-Path $TestDrive 'captures.md'

    & (Join-Path $PSScriptRoot '../scripts/capture/New-GlyGlyphSetGalleryTape.ps1') -OutputPath $tapePath
    & (Join-Path $PSScriptRoot '../scripts/capture/New-GlyCaptureGalleryDocs.ps1') -OutputPath $galleryPath

    $tape = Get-Content -LiteralPath $tapePath
    $gallery = Get-Content -Raw -LiteralPath $galleryPath

    @($tape | Where-Object { $_ -like 'Screenshot assets/captures/glyph-sets/*.png' }).Count | Should -Be 5
    @($tape | Where-Object { $_ -like 'Wait+Screen /Glyph set: */' }).Count | Should -Be 5
    ([regex]::Matches($gallery, '<figure>')).Count | Should -Be 95
    ([regex]::Matches($gallery, 'theme preview with Nerd Fonts glyphs')).Count | Should -Be 90
    ([regex]::Matches($gallery, 'glyph set preview with the DefaultDark theme')).Count | Should -Be 5
  }
}
