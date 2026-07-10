Describe 'gly benchmarks' {
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
    $rendering.Scenario | Should -Be @('DisplayName', 'FormatTable', 'ShowGly')
    $rendering.Iterations | Should -Be @(1, 1, 1)
  }
}
