[CmdletBinding()]
param(
  [int] $ItemCount = 3000,
  [int] $Iterations = 3
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Measure-Case {
  param(
    [string] $Name,
    [scriptblock] $Action
  )

  & $Action | Out-Null
  $samples = for ($iteration = 0; $iteration -lt $Iterations; $iteration++) {
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
    [GC]::Collect()

    $timer = [Diagnostics.Stopwatch]::StartNew()
    & $Action | Out-Null
    $timer.Stop()
    $timer.Elapsed.TotalMilliseconds
  }

  $ordered = @($samples | Sort-Object)
  [pscustomobject]@{
    Scenario = $Name
    MedianMs = [Math]::Round($ordered[[int] [Math]::Floor($ordered.Count / 2)], 2)
    MinMs = [Math]::Round($ordered[0], 2)
    MaxMs = [Math]::Round($ordered[-1], 2)
  }
}

$dataPath = Join-Path ([IO.Path]::GetTempPath()) ('gly-prototype-{0:N}' -f [guid]::NewGuid())
if (Test-Path -LiteralPath $dataPath) {
  throw "Temporary benchmark path already exists: $dataPath"
}

New-Item -ItemType Directory -Path $dataPath | Out-Null
try {
  $extensions = @('.ps1', '.psm1', '.psd1', '.cs', '.js', '.ts', '.d.ts', '.json', '.md', '.tar.gz', '.txt', '.unknown')
  for ($index = 0; $index -lt $ItemCount; $index++) {
    if (($index % 50) -eq 0) {
      New-Item -ItemType Directory -Path (Join-Path $dataPath ('dir-{0:D5}' -f $index)) | Out-Null
      continue
    }

    $name = 'file-{0:D5}{1}' -f $index, $extensions[$index % $extensions.Count]
    $path = Join-Path $dataPath $name
    [IO.File]::WriteAllText($path, "gly benchmark item $index")
    if (($index % 40) -eq 0) {
      $item = Get-Item -LiteralPath $path
      $item.Attributes = $item.Attributes -bor [IO.FileAttributes]::Hidden
    }
  }

  [IO.File]::WriteAllText((Join-Path $dataPath '.gitignore'), "bin/`nobj/`n")
  [IO.File]::WriteAllText((Join-Path $dataPath 'Dockerfile'), "FROM scratch`n")

  Import-Module (Join-Path $PSScriptRoot '../../src/gly.psd1') -Force
  Set-GlyConfiguration -StyleRenderer Ansi -ShowGlyphs $true -ShowColors $true -RespectNoColor $false | Out-Null
  $items = @(Get-ChildItem -LiteralPath $dataPath -Force)
  $module = Get-Module gly

  $baselineTable = $items | Format-Table -View gly.FileSystem.Table | Out-String -Width 4096
  $setupTimer = [Diagnostics.Stopwatch]::StartNew()
  $state = & $module {
    [pscustomobject]@{
      Catalog = @(Get-GlyBuiltInSelectorCatalog)
      Glyphs = $script:GlyGlyphSets['NerdFonts'].Map
      Palette = $script:GlyThemes['DefaultDark'].Palette
    }
  }

  $timer = [Diagnostics.Stopwatch]::StartNew()
  Add-Type -Path (Join-Path $PSScriptRoot 'GlyDisplayNamePrototype.cs')
  $timer.Stop()
  $compileMs = [Math]::Round($timer.Elapsed.TotalMilliseconds, 2)

  $rules = [GlyPrototypeRule[]] @(
    foreach ($definition in $state.Catalog) {
      $selector = $definition.Selector
      $kind = if ($null -eq $selector.Kind) { $null } else { $selector.Kind.ToString() }
      [GlyPrototypeRule]::new(
        $definition.Token,
        $kind,
        $selector.Name,
        [string[]] $selector.NormalizedExtension,
        [string[]] $selector.Glob,
        [IO.FileAttributes[]] $selector.Attributes
      )
    }
  )

  $glyphs = [Collections.Generic.Dictionary[string, string]]::new([StringComparer]::Ordinal)
  foreach ($key in $state.Glyphs.Keys) {
    $glyphs.Add([string] $key, [string] $state.Glyphs[$key])
  }

  $palette = [Collections.Generic.Dictionary[string, string]]::new([StringComparer]::Ordinal)
  foreach ($key in $state.Palette.Keys) {
    $palette.Add([string] $key, [string] $state.Palette[$key])
  }

  $global:GlyPrototypeRenderer = [GlyDisplayNamePrototype]::new($rules, $glyphs, $palette)
  $setupTimer.Stop()
  $setupMs = [Math]::Round($setupTimer.Elapsed.TotalMilliseconds, 2)

  $mismatches = 0
  foreach ($item in $items) {
    $powerShellName = Get-GlyFileSystemDisplayName -InputObject $item
    $prototypeName = $global:GlyPrototypeRenderer.Render($item)
    if ($powerShellName -cne $prototypeName) {
      $mismatches++
      if ($mismatches -le 3) {
        Write-Warning "Mismatch for $($item.Name): PowerShell '$powerShellName'; C# '$prototypeName'"
      }
    }
  }
  if ($mismatches -gt 0) {
    throw "C# prototype produced $mismatches different display names."
  }

  Update-FormatData -PrependPath (Join-Path $PSScriptRoot 'FileSystem.prototype.format.ps1xml')
  $prototypeTable = $items | Format-Table -View gly.FileSystem.Prototype.Table | Out-String -Width 4096
  if ($baselineTable -cne $prototypeTable) {
    throw 'C# prototype table differs from the PowerShell table.'
  }

  Update-FormatData -PrependPath (Join-Path $PSScriptRoot 'FileSystem.prototype-fast.format.ps1xml')
  $fastTable = $items | Format-Table -View gly.FileSystem.Prototype.FastTable | Out-String -Width 4096
  if ($baselineTable -cne $fastTable) {
    throw 'C# prototype table with native Length differs from the PowerShell table.'
  }

  $results = @(
    Measure-Case 'Read Mode property' { foreach ($item in $items) { [void] $item.Mode } }
    Measure-Case 'Direct Length property' { foreach ($item in $items) { if ($item -is [IO.FileInfo]) { [void] $item.Length } } }
    Measure-Case 'Size via module bridge' { foreach ($item in $items) { $currentModule = Get-Module gly; [void] (& $currentModule { param($inputObject) Format-GlyFileSize $inputObject } $item) } }
    Measure-Case 'PowerShell display name' { foreach ($item in $items) { [void] (Get-GlyFileSystemDisplayName $item) } }
    Measure-Case 'C# display name' { foreach ($item in $items) { [void] $global:GlyPrototypeRenderer.Render($item) } }
    Measure-Case 'Native explicit table' { $items | Format-Table Mode, LastWriteTime, Length, Name | Out-String -Width 4096 | Out-Null }
    Measure-Case 'PowerShell gly table' { $items | Format-Table -View gly.FileSystem.Table | Out-String -Width 4096 | Out-Null }
    Measure-Case 'C# prototype table' { $items | Format-Table -View gly.FileSystem.Prototype.Table | Out-String -Width 4096 | Out-Null }
    Measure-Case 'C# with native Length' { $items | Format-Table -View gly.FileSystem.Prototype.FastTable | Out-String -Width 4096 | Out-Null }
  )

  "Items: $($items.Count); prototype setup: $setupMs ms (C# compile: $compileMs ms); output mismatches: $mismatches"
  $results | Format-Table -AutoSize
}
finally {
  Remove-Variable GlyPrototypeRenderer -Scope Global -ErrorAction SilentlyContinue
  if (Test-Path -LiteralPath $dataPath) {
    Remove-Item -LiteralPath $dataPath -Recurse -Force
  }
}
