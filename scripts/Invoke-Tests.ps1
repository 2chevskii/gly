[CmdletBinding()]
param(
  [string] $OutputPath = './artifacts/tests/local',

  [switch] $Coverage,

  [string] $CoverageOutputPath = './artifacts/coverage/coverage.cobertura.xml'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot

function Resolve-RepositoryPath {
  param([Parameter(Mandatory)][string] $Path)

  if ([System.IO.Path]::IsPathRooted($Path)) {
    return [System.IO.Path]::GetFullPath($Path)
  }

  return [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot $Path))
}

$resultDirectory = Resolve-RepositoryPath $OutputPath
$junitPath = Join-Path $resultDirectory 'pester.junit.xml'
$ctrfPath = Join-Path $resultDirectory 'pester.ctrf.json'
$htmlDirectory = Join-Path $resultDirectory 'html'

New-Item -Path $resultDirectory -ItemType Directory -Force | Out-Null

Import-Module Pester -RequiredVersion 5.7.1

$configuration = New-PesterConfiguration
$configuration.Run.Path = Join-Path $repositoryRoot 'tests'
$configuration.Run.PassThru = $true
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputFormat = 'JUnitXml'
$configuration.TestResult.OutputPath = $junitPath

if ($Coverage) {
  $coveragePath = Resolve-RepositoryPath $CoverageOutputPath
  New-Item -Path (Split-Path -Parent $coveragePath) -ItemType Directory -Force | Out-Null

  $configuration.CodeCoverage.Enabled = $true
  $configuration.CodeCoverage.Path = Join-Path $repositoryRoot 'src'
  $configuration.CodeCoverage.RecursePaths = $true
  $configuration.CodeCoverage.ExcludeTests = $true
  $configuration.CodeCoverage.OutputFormat = 'Cobertura'
  $configuration.CodeCoverage.OutputPath = $coveragePath
}

$previousCoverageMode = $env:GLY_PESTER_COVERAGE
if ($Coverage) {
  $env:GLY_PESTER_COVERAGE = '1'
}

try {
  $result = Invoke-Pester -Configuration $configuration
}
finally {
  $env:GLY_PESTER_COVERAGE = $previousCoverageMode
}

Push-Location $repositoryRoot
try {
  $junitArgument = [System.IO.Path]::GetRelativePath($repositoryRoot, $junitPath).Replace('\', '/')
  $ctrfArgument = [System.IO.Path]::GetRelativePath($repositoryRoot, $ctrfPath).Replace('\', '/')
  $htmlArgument = [System.IO.Path]::GetRelativePath($repositoryRoot, $htmlDirectory).Replace('\', '/')

  $ctrfArguments = @('run', 'report:ctrf', '--', $junitArgument, '-o', $ctrfArgument, '-t', 'Pester')
  & npm @ctrfArguments
  if ($LASTEXITCODE -ne 0) {
    throw "junit-to-ctrf failed with exit code $LASTEXITCODE."
  }

  $htmlArguments = @('run', 'report:html', '--', $ctrfArgument, '--output-path', $htmlArgument, '--single-file')
  & npm @htmlArguments
  if ($LASTEXITCODE -ne 0) {
    throw "ctrf-html-reporter failed with exit code $LASTEXITCODE."
  }
}
finally {
  Pop-Location
}

if ($result.Result -ne 'Passed') {
  throw "Pester completed with result '$($result.Result)'."
}
