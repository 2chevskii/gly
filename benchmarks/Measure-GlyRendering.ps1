[CmdletBinding()]
param(
  [string] $ModulePath = (Join-Path $PSScriptRoot '../src/gly.psd1'),
  [string] $DataPath,
  [int] $ItemCount = 3000,
  [int] $Iterations = 5,
  [int] $WarmupIterations = 1,
  [string] $OutputPath,
  [switch] $KeepData
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-GlyBenchmarkData {
  param(
    [Parameter(Mandatory)]
    [string] $Root,

    [Parameter(Mandatory)]
    [int] $Count
  )

  if (Test-Path -LiteralPath $Root) {
    Remove-Item -LiteralPath $Root -Recurse -Force
  }

  New-Item -ItemType Directory -Path $Root | Out-Null

  $extensions = @(
    '.ps1',
    '.psm1',
    '.psd1',
    '.cs',
    '.js',
    '.ts',
    '.d.ts',
    '.json',
    '.md',
    '.tar.gz',
    '.txt',
    '.unknown'
  )

  for ($i = 0; $i -lt $Count; $i++) {
    if (($i % 50) -eq 0) {
      New-Item -ItemType Directory -Path (Join-Path $Root ('dir-{0:D5}' -f $i)) | Out-Null
      continue
    }

    $extension = $extensions[$i % $extensions.Count]
    $name = 'file-{0:D5}{1}' -f $i, $extension
    $path = Join-Path $Root $name
    [System.IO.File]::WriteAllText($path, "gly benchmark item $i")

    if (($i % 40) -eq 0) {
      $item = Get-Item -LiteralPath $path
      $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden
    }
  }

  [System.IO.File]::WriteAllText((Join-Path $Root '.gitignore'), "bin/`nobj/`n")
  [System.IO.File]::WriteAllText((Join-Path $Root 'Dockerfile'), "FROM scratch`n")
}

function Get-GlyBenchmarkSummary {
  param(
    [Parameter(Mandatory)]
    [string] $Scenario,

    [Parameter(Mandatory)]
    [string] $StyleRenderer,

    [Parameter(Mandatory)]
    [double[]] $Measurements
  )

  $ordered = @($Measurements | Sort-Object)
  $middle = [int] [Math]::Floor($ordered.Count / 2)
  $median = if (($ordered.Count % 2) -eq 0) {
    ($ordered[$middle - 1] + $ordered[$middle]) / 2
  }
  else {
    $ordered[$middle]
  }

  $branch = ''
  $commit = ''
  try {
    $branch = (& git branch --show-current 2>$null).Trim()
    $commit = (& git rev-parse --short HEAD 2>$null).Trim()
  }
  catch {
    $branch = ''
    $commit = ''
  }

  [pscustomobject]@{
    Scenario      = $Scenario
    StyleRenderer = $StyleRenderer
    Branch        = $branch
    Commit        = $commit
    ItemCount     = $script:BenchmarkItemCount
    Iterations    = $Measurements.Count
    MinMs         = [Math]::Round(($ordered | Select-Object -First 1), 2)
    MedianMs      = [Math]::Round($median, 2)
    MeanMs        = [Math]::Round((($Measurements | Measure-Object -Average).Average), 2)
    MaxMs         = [Math]::Round(($ordered | Select-Object -Last 1), 2)
  }
}

function Measure-GlyScenario {
  param(
    [Parameter(Mandatory)]
    [string] $Name,

    [Parameter(Mandatory)]
    [string] $StyleRenderer,

    [Parameter(Mandatory)]
    [scriptblock] $ScriptBlock
  )

  for ($i = 0; $i -lt $WarmupIterations; $i++) {
    & $ScriptBlock | Out-Null
  }

  $measurements = for ($i = 0; $i -lt $Iterations; $i++) {
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    & $ScriptBlock | Out-Null
    $stopwatch.Stop()
    $stopwatch.Elapsed.TotalMilliseconds
  }

  Get-GlyBenchmarkSummary `
    -Scenario $Name `
    -StyleRenderer $StyleRenderer `
    -Measurements $measurements
}

$createdData = $false
if ([string]::IsNullOrWhiteSpace($DataPath)) {
  $DataPath = Join-Path ([System.IO.Path]::GetTempPath()) ('gly-benchmark-{0:N}' -f [guid]::NewGuid())
  $createdData = $true
}

$resolvedModulePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ModulePath)
$resolvedDataPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DataPath)

try {
  if ($createdData -or -not (Test-Path -LiteralPath $resolvedDataPath)) {
    New-GlyBenchmarkData -Root $resolvedDataPath -Count $ItemCount
  }

  Remove-Module gly -Force -ErrorAction SilentlyContinue
  Import-Module $resolvedModulePath -Force
  Set-GlyConfiguration -ShowGlyphs $true -ShowColors $true -RespectNoColor $false | Out-Null

  $items = @(Get-ChildItem -LiteralPath $resolvedDataPath -Force)
  $script:BenchmarkItemCount = $items.Count

  $scenarios = [ordered]@{
    DisplayName = {
      foreach ($item in $items) {
        [void] (Get-GlyFileSystemDisplayName -InputObject $item)
      }
    }
    FormatTable = {
      $items | Format-Table | Out-String -Width 4096 | Out-Null
    }
    ShowGly = {
      $items | Show-Gly | Out-Null
    }
  }

  $results = @(
    foreach ($scenario in $scenarios.GetEnumerator()) {
      foreach ($styleRenderer in @('PSStyle', 'Ansi', 'PlainText')) {
        Set-GlyConfiguration -StyleRenderer $styleRenderer | Out-Null
        Measure-GlyScenario `
          -Name $scenario.Key `
          -StyleRenderer $styleRenderer `
          -ScriptBlock $scenario.Value
      }
    }
  )

  if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $results | Format-Table -AutoSize
  }
  else {
    $results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $OutputPath -Encoding utf8
    $results | Format-Table -AutoSize
  }
}
finally {
  if ($createdData -and -not $KeepData -and (Test-Path -LiteralPath $resolvedDataPath)) {
    Remove-Item -LiteralPath $resolvedDataPath -Recurse -Force
  }
}
