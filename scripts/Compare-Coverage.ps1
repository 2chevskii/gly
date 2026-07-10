[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string] $CurrentPath,

  [string] $BaselinePath,

  [ValidateRange(0, 100)]
  [double] $MaximumRegression = 1.0,

  [string] $SummaryPath = './artifacts/coverage/CoverageRegression.md'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-CoberturaLineCoverage {
  param([Parameter(Mandatory)][string] $Path)

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "Cobertura report was not found: $Path"
  }

  [xml] $report = Get-Content -Raw -LiteralPath $Path
  $lineRate = [double]::Parse(
    $report.DocumentElement.GetAttribute('line-rate'),
    [System.Globalization.CultureInfo]::InvariantCulture
  )

  return $lineRate * 100
}

$currentCoverage = Get-CoberturaLineCoverage $CurrentPath
$summaryDirectory = Split-Path -Parent $SummaryPath
if (-not [string]::IsNullOrWhiteSpace($summaryDirectory)) {
  New-Item -Path $summaryDirectory -ItemType Directory -Force | Out-Null
}

if ([string]::IsNullOrWhiteSpace($BaselinePath) -or -not (Test-Path -LiteralPath $BaselinePath -PathType Leaf)) {
  @(
    '## Coverage regression gate'
    ''
    "Current line coverage: **$($currentCoverage.ToString('F2'))%**"
    ''
    'No successful default-branch coverage artifact is available yet. This run establishes the baseline.'
  ) | Set-Content -LiteralPath $SummaryPath -Encoding utf8
  return
}

$baselineCoverage = Get-CoberturaLineCoverage $BaselinePath
$change = $currentCoverage - $baselineCoverage
$minimumAllowed = $baselineCoverage - $MaximumRegression
$passed = $currentCoverage -ge $minimumAllowed
$status = if ($passed) { 'Passed' } else { 'Failed' }

@(
  '## Coverage regression gate'
  ''
  '| Current | Baseline | Change | Allowed drop | Status |'
  '| ---: | ---: | ---: | ---: | :--- |'
  "| $($currentCoverage.ToString('F2'))% | $($baselineCoverage.ToString('F2'))% | $($change.ToString('+0.00;-0.00;0.00')) pp | $($MaximumRegression.ToString('F2')) pp | **$status** |"
) | Set-Content -LiteralPath $SummaryPath -Encoding utf8

if (-not $passed) {
  throw "Line coverage regressed by $((-1 * $change).ToString('F2')) percentage points; the maximum allowed regression is $($MaximumRegression.ToString('F2'))."
}
