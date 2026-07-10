[CmdletBinding()]
param(
  [int] $ItemCount = 3000,
  [int] $ImportIterations = 10,
  [int] $ImportWarmupIterations = 2,
  [int] $RenderingIterations = 5,
  [int] $RenderingWarmupIterations = 1,
  [string] $OutputPath,
  [switch] $KeepData,
  [switch] $Worker,
  [ValidateSet('Import', 'Rendering')]
  [string] $Scenario,
  [string] $ModulePath,
  [string] $DataPath,
  [int] $Iterations,
  [int] $WarmupIterations
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-ComparisonSummary {
  param(
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

  [pscustomobject]@{
    MinMs    = [Math]::Round($ordered[0], 2)
    MedianMs = [Math]::Round($median, 2)
    MeanMs   = [Math]::Round((($Measurements | Measure-Object -Average).Average), 2)
    MaxMs    = [Math]::Round($ordered[-1], 2)
  }
}

if ($Worker) {
  if ([string]::IsNullOrWhiteSpace($Scenario) -or
      [string]::IsNullOrWhiteSpace($ModulePath) -or
      $Iterations -lt 1 -or
      $WarmupIterations -lt 0) {
    throw 'Worker mode requires Scenario, ModulePath, Iterations, and WarmupIterations.'
  }

  if ($Scenario -eq 'Import') {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    Import-Module $ModulePath -Force
    $stopwatch.Stop()
    [Console]::Out.WriteLine($stopwatch.Elapsed.TotalMilliseconds.ToString([cultureinfo]::InvariantCulture))
    return
  }

  if ([string]::IsNullOrWhiteSpace($DataPath)) {
    throw 'The rendering worker requires DataPath.'
  }

  Import-Module $ModulePath -Force
  $items = @(Get-ChildItem -LiteralPath $DataPath -Force)
  $render = {
    $items | Format-Table | Out-String -Width 4096 | Out-Null
  }

  for ($i = 0; $i -lt $WarmupIterations; $i++) {
    & $render
  }

  $measurements = for ($i = 0; $i -lt $Iterations; $i++) {
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    & $render
    $stopwatch.Stop()
    $stopwatch.Elapsed.TotalMilliseconds
  }

  [Console]::Out.WriteLine(($measurements | ConvertTo-Json -Compress))
  return
}

if ($ItemCount -lt 1 -or $ImportIterations -lt 1 -or $RenderingIterations -lt 1 -or
    $ImportWarmupIterations -lt 0 -or $RenderingWarmupIterations -lt 0) {
  throw 'Item and iteration counts must be positive; warmup counts cannot be negative.'
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$powerShellPath = (Get-Process -Id $PID).Path
$comparisonRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('gly-module-comparison-{0:N}' -f [guid]::NewGuid())
$moduleRoot = Join-Path $comparisonRoot 'modules'
$generatedDataPath = Join-Path $comparisonRoot 'data'
$workerPath = $PSCommandPath

$modules = @(
  [pscustomobject]@{
    Name = 'gly'
    Version = (Test-ModuleManifest (Join-Path $repositoryRoot 'src/gly.psd1')).Version.ToString()
    Path = Join-Path $repositoryRoot 'src/gly.psd1'
  }
  [pscustomobject]@{ Name = 'PSFileIcons'; Version = '0.1.1'; Path = $null }
  [pscustomobject]@{ Name = 'GlyphShell'; Version = '0.1.1'; Path = $null }
  [pscustomobject]@{ Name = 'Terminal-Icons'; Version = '0.11.0'; Path = $null }
)

try {
  New-Item -ItemType Directory -Path $moduleRoot, $generatedDataPath -Force | Out-Null

  foreach ($module in $modules | Select-Object -Skip 1) {
    Save-PSResource `
      -Name $module.Name `
      -Version $module.Version `
      -Repository PSGallery `
      -Path $moduleRoot `
      -TrustRepository
    $module.Path = Join-Path $moduleRoot "$($module.Name)/$($module.Version)/$($module.Name).psd1"
  }

  $extensions = @('.ps1', '.psm1', '.psd1', '.cs', '.js', '.ts', '.d.ts', '.json', '.md', '.tar.gz', '.txt', '.unknown')
  for ($i = 0; $i -lt $ItemCount; $i++) {
    if (($i % 50) -eq 0) {
      New-Item -ItemType Directory -Path (Join-Path $generatedDataPath ('dir-{0:D5}' -f $i)) | Out-Null
      continue
    }

    $extension = $extensions[$i % $extensions.Count]
    [System.IO.File]::WriteAllText(
      (Join-Path $generatedDataPath ('file-{0:D5}{1}' -f $i, $extension)),
      "comparison benchmark item $i"
    )
  }

  $results = foreach ($module in $modules) {
    for ($i = 0; $i -lt $ImportWarmupIterations; $i++) {
      & $powerShellPath -NoProfile -NonInteractive -File $workerPath `
        -Worker -Scenario Import -ModulePath $module.Path -Iterations 1 -WarmupIterations 0 | Out-Null
      if ($LASTEXITCODE -ne 0) {
        throw "$($module.Name) import warmup failed with exit code $LASTEXITCODE."
      }
    }

    $importMeasurements = for ($i = 0; $i -lt $ImportIterations; $i++) {
      $value = & $powerShellPath -NoProfile -NonInteractive -File $workerPath `
        -Worker -Scenario Import -ModulePath $module.Path -Iterations 1 -WarmupIterations 0
      if ($LASTEXITCODE -ne 0) {
        throw "$($module.Name) import benchmark failed with exit code $LASTEXITCODE."
      }
      [double]::Parse($value, [cultureinfo]::InvariantCulture)
    }

    $renderingJson = & $powerShellPath -NoProfile -NonInteractive -File $workerPath `
      -Worker -Scenario Rendering -ModulePath $module.Path -DataPath $generatedDataPath `
      -Iterations $RenderingIterations -WarmupIterations $RenderingWarmupIterations
    if ($LASTEXITCODE -ne 0) {
      throw "$($module.Name) rendering benchmark failed with exit code $LASTEXITCODE."
    }
    $renderingMeasurements = [double[]] ($renderingJson | ConvertFrom-Json)

    $importSummary = Get-ComparisonSummary -Measurements $importMeasurements
    $renderingSummary = Get-ComparisonSummary -Measurements $renderingMeasurements

    [pscustomobject]@{
      Module = $module.Name
      Version = $module.Version
      Scenario = 'ImportModule'
      ItemCount = $null
      Iterations = $ImportIterations
      WarmupIterations = $ImportWarmupIterations
      MinMs = $importSummary.MinMs
      MedianMs = $importSummary.MedianMs
      MeanMs = $importSummary.MeanMs
      MaxMs = $importSummary.MaxMs
    }
    [pscustomobject]@{
      Module = $module.Name
      Version = $module.Version
      Scenario = 'FormatTable'
      ItemCount = $ItemCount
      Iterations = $RenderingIterations
      WarmupIterations = $RenderingWarmupIterations
      MinMs = $renderingSummary.MinMs
      MedianMs = $renderingSummary.MedianMs
      MeanMs = $renderingSummary.MeanMs
      MaxMs = $renderingSummary.MaxMs
    }
  }

  if (-not [string]::IsNullOrWhiteSpace($OutputPath)) {
    $resolvedOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    $outputDirectory = Split-Path -Parent $resolvedOutputPath
    if (-not [string]::IsNullOrWhiteSpace($outputDirectory)) {
      New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }
    $results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $resolvedOutputPath -Encoding utf8
  }

  $results | Format-Table -AutoSize
}
finally {
  if (-not $KeepData -and (Test-Path -LiteralPath $comparisonRoot)) {
    Remove-Item -LiteralPath $comparisonRoot -Recurse -Force
  }
  elseif ($KeepData) {
    Write-Verbose "Comparison data retained at: $comparisonRoot"
  }
}
