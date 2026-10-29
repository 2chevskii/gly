param(
  [string] $BenchmarkPath,
  [string] $ResultPath
)

$ErrorActionPreference = 'Stop'
$global:GlyStyleRenderer = 'PlainText'
$result = & $BenchmarkPath -ItemCount 42 -Iterations 2 -PassThru
if ($global:GlyStyleRenderer -ne 'PlainText') {
  throw 'The prototype benchmark did not restore the style preference.'
}
$rule = [GlyPrototypeRule]::new('docker', 'File', $null, @(), @('Dockerfile.*'), @())
if ($rule.Matches('File', "Dockerfile.test`n", [IO.FileAttributes]::Normal)) {
  throw 'Prototype globs must match the entire file name, including its final newline.'
}
$item = Get-Item -LiteralPath $BenchmarkPath
$defaultTable = $item | Format-Table | Out-String -Width 4096
$productionTable = $item | Format-Table -View gly.FileSystem.Table | Out-String -Width 4096
if ($defaultTable -cne $productionTable) {
  throw 'The prototype benchmark left its temporary view selected for ordinary file listings.'
}
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $ResultPath -Encoding utf8
