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
}
