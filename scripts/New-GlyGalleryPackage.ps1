param(
  [string] $OutputPath = 'artifacts/psgallery',
  [switch] $Clean
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repositoryRoot 'src'
$resolvedOutputPath = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
  $OutputPath
} else {
  Join-Path $repositoryRoot $OutputPath
}

$moduleRoot = Join-Path $resolvedOutputPath 'gly'
$manifestPath = Join-Path $sourceRoot 'gly.psd1'

if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
  throw "Module manifest was not found: $manifestPath"
}

if ($Clean -and (Test-Path -LiteralPath $moduleRoot)) {
  Remove-Item -LiteralPath $moduleRoot -Recurse -Force
}

New-Item -Path $moduleRoot -ItemType Directory -Force | Out-Null
Copy-Item -Path (Join-Path $sourceRoot '*') -Destination $moduleRoot -Recurse -Force

$packagedManifestPath = Join-Path $moduleRoot 'gly.psd1'
Test-ModuleManifest -Path $packagedManifestPath | Out-Null

Get-Item -LiteralPath $moduleRoot
