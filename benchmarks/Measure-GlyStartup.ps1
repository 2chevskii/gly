[CmdletBinding()]
param(
  [string] $ModulePath = (Join-Path $PSScriptRoot '../src/gly.psd1'),
  [int] $Iterations = 10,
  [int] $WarmupIterations = 2,
  [string] $OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolvedModulePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ModulePath)
$escapedModulePath = $resolvedModulePath.Replace("'", "''")
$command = @"
`$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Import-Module '$escapedModulePath'
`$stopwatch.Stop()
`$stopwatch.Elapsed.TotalMilliseconds
"@

for ($i = 0; $i -lt $WarmupIterations; $i++) {
  & (Get-Process -Id $PID).Path -NoProfile -NonInteractive -Command $command | Out-Null
}

$measurements = for ($i = 0; $i -lt $Iterations; $i++) {
  $value = & (Get-Process -Id $PID).Path -NoProfile -NonInteractive -Command $command
  if ($LASTEXITCODE -ne 0) {
    throw "Startup benchmark child process failed with exit code $LASTEXITCODE."
  }
  [double] $value
}

$ordered = @($measurements | Sort-Object)
$middle = [int] [Math]::Floor($ordered.Count / 2)
$median = if (($ordered.Count % 2) -eq 0) {
  ($ordered[$middle - 1] + $ordered[$middle]) / 2
}
else {
  $ordered[$middle]
}

$result = [pscustomobject]@{
  Scenario   = 'ImportModule'
  Iterations = $measurements.Count
  MinMs      = [Math]::Round($ordered[0], 2)
  MedianMs   = [Math]::Round($median, 2)
  MeanMs     = [Math]::Round((($measurements | Measure-Object -Average).Average), 2)
  MaxMs      = [Math]::Round($ordered[-1], 2)
}

if (-not [string]::IsNullOrWhiteSpace($OutputPath)) {
  $result | ConvertTo-Json | Set-Content -LiteralPath $OutputPath -Encoding utf8
}

$result
