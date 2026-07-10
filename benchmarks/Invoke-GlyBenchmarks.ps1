[CmdletBinding()]
param(
  [string] $ModulePath = (Join-Path $PSScriptRoot '../src/gly.psd1'),
  [string] $DataPath,
  [int] $ItemCount = 3000,
  [int] $RenderingIterations = 5,
  [int] $RenderingWarmupIterations = 1,
  [int] $StartupIterations = 10,
  [int] $StartupWarmupIterations = 2,
  [string] $OutputPath,
  [switch] $KeepData
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$resolvedModulePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ModulePath)
$resolvedOutputPath = if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  $null
}
else {
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
}

if ($null -ne $resolvedOutputPath) {
  New-Item -ItemType Directory -Path $resolvedOutputPath -Force | Out-Null
}

$benchmarks = @(
  [pscustomobject]@{
    Name      = 'Startup'
    Script    = Join-Path $PSScriptRoot 'Measure-GlyStartup.ps1'
    Arguments = @(
      '-ModulePath', $resolvedModulePath,
      '-Iterations', $StartupIterations,
      '-WarmupIterations', $StartupWarmupIterations
    )
    Output    = if ($null -eq $resolvedOutputPath) { $null } else { Join-Path $resolvedOutputPath 'startup.json' }
  }
  [pscustomobject]@{
    Name      = 'Rendering'
    Script    = Join-Path $PSScriptRoot 'Measure-GlyRendering.ps1'
    Arguments = @(
      '-ModulePath', $resolvedModulePath,
      '-ItemCount', $ItemCount,
      '-Iterations', $RenderingIterations,
      '-WarmupIterations', $RenderingWarmupIterations
    )
    Output    = if ($null -eq $resolvedOutputPath) { $null } else { Join-Path $resolvedOutputPath 'rendering.json' }
  }
)

if (-not [string]::IsNullOrWhiteSpace($DataPath)) {
  $resolvedDataPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DataPath)
  $benchmarks[1].Arguments += @('-DataPath', $resolvedDataPath)
}

if ($KeepData) {
  $benchmarks[1].Arguments += '-KeepData'
}

$runningBenchmarks = foreach ($benchmark in $benchmarks) {
  $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
  $startInfo.FileName = (Get-Process -Id $PID).Path
  $startInfo.WorkingDirectory = $repositoryRoot
  $startInfo.UseShellExecute = $false
  $startInfo.RedirectStandardOutput = $true
  $startInfo.RedirectStandardError = $true
  $startInfo.ArgumentList.Add('-NoProfile')
  $startInfo.ArgumentList.Add('-NonInteractive')
  $startInfo.ArgumentList.Add('-File')
  $startInfo.ArgumentList.Add($benchmark.Script)

  foreach ($argument in $benchmark.Arguments) {
    $startInfo.ArgumentList.Add([string] $argument)
  }

  if ($null -ne $benchmark.Output) {
    $startInfo.ArgumentList.Add('-OutputPath')
    $startInfo.ArgumentList.Add($benchmark.Output)
  }

  $process = [System.Diagnostics.Process]::new()
  $process.StartInfo = $startInfo
  if (-not $process.Start()) {
    throw "Failed to start the $($benchmark.Name) benchmark."
  }

  [pscustomobject]@{
    Name       = $benchmark.Name
    Process    = $process
    OutputTask = $process.StandardOutput.ReadToEndAsync()
    ErrorTask  = $process.StandardError.ReadToEndAsync()
  }
}

$results = foreach ($benchmark in $runningBenchmarks) {
  $benchmark.Process.WaitForExit()

  [pscustomobject]@{
    Name     = $benchmark.Name
    ExitCode = $benchmark.Process.ExitCode
    Output   = $benchmark.OutputTask.GetAwaiter().GetResult()
    Error    = $benchmark.ErrorTask.GetAwaiter().GetResult()
  }

  $benchmark.Process.Dispose()
}

foreach ($result in $results) {
  if (-not [string]::IsNullOrEmpty($result.Output)) {
    [Console]::Out.Write($result.Output)
  }
  if (-not [string]::IsNullOrEmpty($result.Error)) {
    [Console]::Error.Write($result.Error)
  }
}

$failedBenchmarks = @($results | Where-Object ExitCode -ne 0)
if ($failedBenchmarks.Count -gt 0) {
  $failureSummary = $failedBenchmarks | ForEach-Object { "$($_.Name) ($($_.ExitCode))" }
  throw "Benchmark processes failed: $($failureSummary -join ', ')."
}
