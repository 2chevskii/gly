Describe 'module comparison workers' {
  BeforeAll {
    $benchmarkPath = Join-Path $PSScriptRoot '../benchmarks/Measure-ModuleComparison.ps1'
    $powerShellPath = (Get-Process -Id $PID).Path
  }

  It 'normalizes inherited color preferences only in the worker process' {
    $modulePath = Join-Path $TestDrive 'ColorFixture.psm1'
    @'
if (Test-Path Env:NO_COLOR) { throw 'NO_COLOR was inherited.' }
if ($PSVersionTable.PSVersion -ge [version] '7.2' -and $PSStyle.OutputRendering -ne 'Ansi') {
  throw 'ANSI output is not enabled.'
}
'@ | Set-Content -LiteralPath $modulePath
    $originalNoColor = $env:NO_COLOR
    try {
      $env:NO_COLOR = '1'
      $result = & $powerShellPath -NoProfile -NonInteractive -File $benchmarkPath `
        -Worker -Scenario Import -ModulePath $modulePath -Iterations 1 -WarmupIterations 0
      $LASTEXITCODE | Should -Be 0
      [double]::Parse($result, [cultureinfo]::InvariantCulture) | Should -BeGreaterThan 0
      $env:NO_COLOR | Should -Be '1'
    }
    finally {
      $env:NO_COLOR = $originalNoColor
    }
  }

  It 'returns one rendering measurement for a single requested iteration' {
    $modulePath = Join-Path $PSScriptRoot '../src/gly.psd1'
    $dataPath = Join-Path $TestDrive 'data'
    New-Item -ItemType Directory -Path $dataPath | Out-Null
    Set-Content -LiteralPath (Join-Path $dataPath 'sample.ps1') -Value 'sample'
    $result = & $powerShellPath -NoProfile -NonInteractive -File $benchmarkPath `
      -Worker -Scenario Rendering -ModulePath $modulePath -DataPath $dataPath `
      -Iterations 1 -WarmupIterations 0
    $LASTEXITCODE | Should -Be 0
    $measurements = @($result | ConvertFrom-Json)
    $measurements.Count | Should -Be 1
    $measurements[0] | Should -BeGreaterThan 0
  }
}
