function Show-GlyGrid {
  [CmdletBinding(DefaultParameterSetName = 'Default')]
  param(
    [Parameter(ValueFromPipeline, ParameterSetName = 'Input')]
    [System.IO.FileSystemInfo] $InputObject,

    [Parameter(ParameterSetName = 'Path')]
    [string[]] $Path,

    [Parameter(ParameterSetName = 'LiteralPath')]
    [string[]] $LiteralPath
  )

  begin {
    $pipelineItems = @()
  }

  process {
    if ($PSBoundParameters.ContainsKey('InputObject')) {
      $pipelineItems += $InputObject
    }
  }

  end {
    $items = @(Get-GlyFileSystemItems -Path $Path -LiteralPath $LiteralPath -InputObject $pipelineItems)
    if ($items.Count -eq 0) {
      return
    }

    $names = @($items | ForEach-Object { Get-GlyFileSystemDisplayName -InputObject $_ })
    $widths = @($names | ForEach-Object { (Remove-GlyAnsiEscape -Text $_).Length })
    $maxWidth = (($widths | Measure-Object -Maximum).Maximum + 2)
    if ($maxWidth -lt 1) { $maxWidth = 1 }

    $terminalWidth = 80
    if ($Host.UI.RawUI.BufferSize.Width -gt 0) {
      $terminalWidth = $Host.UI.RawUI.BufferSize.Width
    }

    $columns = [Math]::Max(1, [Math]::Floor($terminalWidth / $maxWidth))
    for ($i = 0; $i -lt $names.Count; $i += $columns) {
      $line = ''
      for ($column = 0; $column -lt $columns -and ($i + $column) -lt $names.Count; $column++) {
        $name = $names[$i + $column]
        $visible = (Remove-GlyAnsiEscape -Text $name).Length
        $padding = [Math]::Max(1, $maxWidth - $visible)
        $line += $name + (' ' * $padding)
      }
      $line.TrimEnd()
    }
  }
}
