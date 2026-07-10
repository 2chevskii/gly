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

  It 'runs independent benchmark suites and writes their results' {
    $benchmarkPath = Join-Path $PSScriptRoot '../benchmarks/Invoke-GlyBenchmarks.ps1'
    $outputPath = Join-Path $TestDrive 'results'
    $powerShellPath = (Get-Process -Id $PID).Path

    & $powerShellPath -NoProfile -NonInteractive -File $benchmarkPath `
      -ItemCount 10 `
      -RenderingIterations 1 `
      -RenderingWarmupIterations 0 `
      -StartupIterations 2 `
      -StartupWarmupIterations 0 `
      -OutputPath $outputPath | Out-Null

    $LASTEXITCODE | Should -Be 0

    $startupPath = Join-Path $outputPath 'startup.json'
    $renderingPath = Join-Path $outputPath 'rendering.json'
    $startupPath | Should -Exist
    $renderingPath | Should -Exist

    $startup = Get-Content -LiteralPath $startupPath -Raw | ConvertFrom-Json
    $rendering = @(Get-Content -LiteralPath $renderingPath -Raw | ConvertFrom-Json)

    $startup.Scenario | Should -Be 'ImportModule'
    $startup.Iterations | Should -Be 2
    $rendering.Count | Should -Be 9
    @($rendering.Scenario | Sort-Object -Unique) | Should -Be @('DisplayName', 'FormatTable', 'ShowGly')
    @($rendering.Iterations | Sort-Object -Unique) | Should -Be 1
  }
}
