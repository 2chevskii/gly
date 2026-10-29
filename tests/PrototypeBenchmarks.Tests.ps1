Describe 'C# rendering prototype benchmark' {
  It 'checks output parity, averages the two middle samples, and restores the style preference' {
    $benchmarkPath = Join-Path $PSScriptRoot '../benchmarks/prototypes/Measure-GlyPrototype.ps1'
    $powerShellPath = (Get-Process -Id $PID).Path
    $resultPath = Join-Path $TestDrive 'prototype.json'
    $fixturePath = Join-Path $PSScriptRoot 'fixtures/Invoke-PrototypeBenchmarkFixture.ps1'

    & $powerShellPath -NoProfile -NonInteractive -File $fixturePath `
      -BenchmarkPath $benchmarkPath -ResultPath $resultPath
    $LASTEXITCODE | Should -Be 0

    $result = Get-Content -LiteralPath $resultPath -Raw | ConvertFrom-Json
    $result.ItemCount | Should -Be 44
    $result.Mismatches | Should -Be 0
    $result.Results.Count | Should -Be 9
    foreach ($scenario in $result.Results) {
      # The timings are rounded independently; allow one hundredth of a millisecond.
      [Math]::Abs($scenario.MedianMs - ($scenario.MinMs + $scenario.MaxMs) / 2) | Should -BeLessOrEqual 0.011
    }
  }

  It 'rejects a nonpositive <Parameter> before creating benchmark data' -ForEach @(
    @{ Parameter = 'ItemCount' }
    @{ Parameter = 'Iterations' }
  ) {
    $benchmarkPath = Join-Path $PSScriptRoot '../benchmarks/prototypes/Measure-GlyPrototype.ps1'
    $arguments = @{ $Parameter = 0 }
    { & $benchmarkPath @arguments } | Should -Throw '*greater than or equal to 1*'
  }
}
