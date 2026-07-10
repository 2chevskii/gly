Describe 'benchmark regression comparison' {
  BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot '../scripts/Compare-Benchmarks.ps1'

    function Write-BenchmarkResult {
      param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [object[]] $Result
      )

      New-Item -Path (Split-Path -Parent $Path) -ItemType Directory -Force | Out-Null
      $Result | ConvertTo-Json | Set-Content -LiteralPath $Path -Encoding utf8
    }
  }

  It 'establishes a baseline when no prior artifact exists' {
    $currentPath = Join-Path $TestDrive 'current/startup.json'
    $summaryPath = Join-Path $TestDrive 'summary/no-baseline.md'
    Write-BenchmarkResult -Path $currentPath -Result @(
      [pscustomobject]@{ Scenario = 'ImportModule'; MedianMs = 25.0 }
    )

    { & $scriptPath -CurrentPath $currentPath -BaselinePath (Join-Path $TestDrive 'missing') -SummaryPath $summaryPath } |
      Should -Not -Throw

    (Get-Content -Raw -LiteralPath $summaryPath) | Should -Match 'establishes the baseline'
  }

  It 'passes results within the allowed regression' {
    $currentPath = Join-Path $TestDrive 'within/current.json'
    $baselinePath = Join-Path $TestDrive 'within/baseline.json'
    $summaryPath = Join-Path $TestDrive 'within/summary.md'
    Write-BenchmarkResult -Path $currentPath -Result @(
      [pscustomobject]@{ Scenario = 'DisplayName'; ItemCount = 3000; MedianMs = 109.0 }
    )
    Write-BenchmarkResult -Path $baselinePath -Result @(
      [pscustomobject]@{ Scenario = 'DisplayName'; ItemCount = 3000; MedianMs = 100.0 }
    )

    { & $scriptPath -CurrentPath $currentPath -BaselinePath $baselinePath -MaximumRegressionPercent 10 -SummaryPath $summaryPath } |
      Should -Not -Throw

    (Get-Content -Raw -LiteralPath $summaryPath) | Should -Match '\+9\.00%.*Passed'
  }

  It 'fails results beyond the allowed regression and still writes the summary' {
    $currentPath = Join-Path $TestDrive 'regressed/current.json'
    $baselinePath = Join-Path $TestDrive 'regressed/baseline.json'
    $summaryPath = Join-Path $TestDrive 'regressed/summary.md'
    Write-BenchmarkResult -Path $currentPath -Result @(
      [pscustomobject]@{ Scenario = 'ShowGly'; ItemCount = 3000; MedianMs = 121.0 }
    )
    Write-BenchmarkResult -Path $baselinePath -Result @(
      [pscustomobject]@{ Scenario = 'ShowGly'; ItemCount = 3000; MedianMs = 100.0 }
    )

    { & $scriptPath -CurrentPath $currentPath -BaselinePath $baselinePath -MaximumRegressionPercent 20 -SummaryPath $summaryPath } |
      Should -Throw '*exceeded the maximum allowed regression*'

    (Get-Content -Raw -LiteralPath $summaryPath) | Should -Match '\+21\.00%.*Failed'
  }

  It 'treats new benchmark dimensions as independent baselines' {
    $currentPath = Join-Path $TestDrive 'dimensions/current.json'
    $baselinePath = Join-Path $TestDrive 'dimensions/baseline.json'
    $summaryPath = Join-Path $TestDrive 'dimensions/summary.md'
    Write-BenchmarkResult -Path $currentPath -Result @(
      [pscustomobject]@{ Scenario = 'FormatTable'; Backend = 'PlainText'; ItemCount = 3000; MedianMs = 150.0 }
    )
    Write-BenchmarkResult -Path $baselinePath -Result @(
      [pscustomobject]@{ Scenario = 'FormatTable'; Backend = 'Ansi'; ItemCount = 3000; MedianMs = 100.0 }
    )

    { & $scriptPath -CurrentPath $currentPath -BaselinePath $baselinePath -SummaryPath $summaryPath } |
      Should -Not -Throw

    (Get-Content -Raw -LiteralPath $summaryPath) | Should -Match 'Baseline unavailable'
  }
}
