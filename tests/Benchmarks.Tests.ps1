Describe 'gly benchmarks' {
  It 'measures each rendering scenario with every style backend' {
    $benchmarkPath = Join-Path $PSScriptRoot '../benchmarks/Measure-GlyRendering.ps1'
    $outputPath = Join-Path $TestDrive 'rendering.json'
    $pwshPath = (Get-Process -Id $PID).Path

    & $pwshPath `
      -NoProfile `
      -NonInteractive `
      -File $benchmarkPath `
      -ItemCount 4 `
      -Iterations 1 `
      -WarmupIterations 0 `
      -OutputPath $outputPath |
      Out-Null

    $LASTEXITCODE | Should -Be 0
    $results = @(Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json)
    $results.Count | Should -Be 9

    $expected = foreach ($scenario in @('DisplayName', 'FormatTable', 'ShowGly')) {
      foreach ($styleRenderer in @('PSStyle', 'Ansi', 'PlainText')) {
        "$scenario|$styleRenderer"
      }
    }
    $actual = $results | ForEach-Object { "$($_.Scenario)|$($_.StyleRenderer)" }

    @(Compare-Object -ReferenceObject $expected -DifferenceObject $actual).Count | Should -Be 0
  }
}
