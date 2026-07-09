function Show-Gly {
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
    $items = Get-GlyFileSystemItem -Path $Path -LiteralPath $LiteralPath -InputObject $pipelineItems
    foreach ($item in $items) {
      ConvertTo-GlyDisplayRecord -InputObject $item
    }
  }
}
