[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string] $CurrentPath,

  [string] $BaselinePath,

  [ValidateRange(0, 1000)]
  [double] $MaximumRegressionPercent = 20.0,

  [string] $SummaryPath = './artifacts/benchmarks/BenchmarkRegression.md'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Import-BenchmarkResult {
  param(
    [Parameter(Mandatory)]
    [string] $Path,

    [switch] $AllowMissing
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    if ($AllowMissing) {
      return @()
    }

    throw "Benchmark result path was not found: $Path"
  }

  $files = @(if (Test-Path -LiteralPath $Path -PathType Leaf) {
      Get-Item -LiteralPath $Path
    }
    else {
      Get-ChildItem -LiteralPath $Path -Filter '*.json' -File -Recurse | Sort-Object FullName
    })

  if ($files.Count -eq 0) {
    if ($AllowMissing) {
      return @()
    }

    throw "No benchmark JSON files were found under: $Path"
  }

  $results = foreach ($file in $files) {
    $document = Get-Content -Raw -LiteralPath $file.FullName | ConvertFrom-Json
    foreach ($result in @($document)) {
      if ($null -eq $result.PSObject.Properties['Scenario'] -or [string]::IsNullOrWhiteSpace([string] $result.Scenario)) {
        throw "Benchmark result '$($file.FullName)' contains a record without a scenario."
      }

      if ($null -eq $result.PSObject.Properties['MedianMs']) {
        throw "Benchmark scenario '$($result.Scenario)' in '$($file.FullName)' has no MedianMs value."
      }

      $median = [double] $result.MedianMs
      if ($median -le 0) {
        throw "Benchmark scenario '$($result.Scenario)' in '$($file.FullName)' has a non-positive MedianMs value."
      }

      $result
    }
  }

  return @($results)
}

function Get-BenchmarkIdentity {
  param([Parameter(Mandatory)][psobject] $Result)

  $measurementProperties = @(
    'Branch',
    'Commit',
    'Iterations',
    'MinMs',
    'MedianMs',
    'MeanMs',
    'MaxMs'
  )

  $properties = @(
    $Result.PSObject.Properties['Scenario']
    $Result.PSObject.Properties |
      Where-Object { $_.Name -ne 'Scenario' -and $_.Name -notin $measurementProperties } |
      Sort-Object Name
  )

  return ($properties | ForEach-Object { '{0}={1}' -f $_.Name, $_.Value }) -join ';'
}

function Get-BenchmarkLabel {
  param([Parameter(Mandatory)][psobject] $Result)

  $identity = Get-BenchmarkIdentity $Result
  return $identity.Replace('|', '\|')
}

$currentResults = @(Import-BenchmarkResult -Path $CurrentPath)
$baselineResults = @(if (-not [string]::IsNullOrWhiteSpace($BaselinePath)) {
    Import-BenchmarkResult -Path $BaselinePath -AllowMissing
  })

$baselineByIdentity = @{}
foreach ($result in $baselineResults) {
  $identity = Get-BenchmarkIdentity $result
  if ($baselineByIdentity.ContainsKey($identity)) {
    throw "The baseline contains duplicate benchmark identity '$identity'."
  }
  $baselineByIdentity[$identity] = $result
}

$summaryDirectory = Split-Path -Parent $SummaryPath
if (-not [string]::IsNullOrWhiteSpace($summaryDirectory)) {
  New-Item -Path $summaryDirectory -ItemType Directory -Force | Out-Null
}

$summary = @(
  '## Benchmark regression gate'
  ''
  "Median execution time may increase by at most **$($MaximumRegressionPercent.ToString('F2'))%** compared with the latest successful ``master`` run."
  ''
  '| Benchmark | Current median | Baseline median | Change | Status |'
  '| :--- | ---: | ---: | ---: | :--- |'
)

$failures = [System.Collections.Generic.List[string]]::new()
$seenCurrent = @{}
$unmatchedCount = 0
foreach ($current in $currentResults) {
  $identity = Get-BenchmarkIdentity $current
  if ($seenCurrent.ContainsKey($identity)) {
    throw "The current results contain duplicate benchmark identity '$identity'."
  }
  $seenCurrent[$identity] = $true

  $label = Get-BenchmarkLabel $current
  $currentMedian = [double] $current.MedianMs
  if (-not $baselineByIdentity.ContainsKey($identity)) {
    $unmatchedCount++
    $summary += "| $label | $($currentMedian.ToString('F2')) ms | — | — | **Baseline unavailable** |"
    continue
  }

  $baselineMedian = [double] $baselineByIdentity[$identity].MedianMs
  $changePercent = (($currentMedian - $baselineMedian) / $baselineMedian) * 100
  $passed = $changePercent -le $MaximumRegressionPercent
  $status = if ($passed) { 'Passed' } else { 'Failed' }
  $summary += "| $label | $($currentMedian.ToString('F2')) ms | $($baselineMedian.ToString('F2')) ms | $($changePercent.ToString('+0.00;-0.00;0.00'))% | **$status** |"

  if (-not $passed) {
    $failures.Add($identity)
  }
}

if ($baselineResults.Count -eq 0) {
  $summary += @(
    ''
    'No successful default-branch benchmark artifact is available yet. This run establishes the baseline.'
  )
}
elseif ($unmatchedCount -gt 0) {
  $summary += @(
    ''
    'Benchmarks without a matching baseline establish their baseline in this run.'
  )
}

$summary | Set-Content -LiteralPath $SummaryPath -Encoding utf8

if ($failures.Count -gt 0) {
  throw "$($failures.Count) benchmark(s) exceeded the maximum allowed regression of $($MaximumRegressionPercent.ToString('F2'))%: $($failures -join ', ')."
}
