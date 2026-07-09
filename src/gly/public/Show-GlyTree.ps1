function Show-GlyTree {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(ValueFromPipeline, ParameterSetName = 'Input')]
        [System.IO.FileSystemInfo] $InputObject,

        [Parameter(ParameterSetName = 'Path')]
        [string[]] $Path,

        [Parameter(ParameterSetName = 'LiteralPath')]
        [string[]] $LiteralPath,

        [int] $Depth = 2
    )

    begin {
        $pipelineItems = @()

        function Write-GlyTreeItem {
            param(
                [System.IO.FileSystemInfo] $Item,
                [string] $Prefix,
                [int] $RemainingDepth,
                [bool] $IsLast,
                [bool] $IsRoot
            )

            $branch = if ($IsRoot) { '' } elseif ($IsLast) { '+-- ' } else { '|-- ' }
            "$Prefix$branch$(Get-GlyFileSystemDisplayName -InputObject $Item)"

            if ($RemainingDepth -le 0 -or $Item -isnot [System.IO.DirectoryInfo]) {
                return
            }

            $children = @(Get-ChildItem -LiteralPath $Item.FullName)
            for ($i = 0; $i -lt $children.Count; $i++) {
                $nextPrefix = if ($IsRoot) {
                    ''
                } elseif ($IsLast) {
                    "$Prefix    "
                } else {
                    "$Prefix|   "
                }
                Write-GlyTreeItem -Item $children[$i] -Prefix $nextPrefix -RemainingDepth ($RemainingDepth - 1) -IsLast ($i -eq ($children.Count - 1)) -IsRoot $false
            }
        }
    }

    process {
        if ($PSBoundParameters.ContainsKey('InputObject')) {
            $pipelineItems += $InputObject
        }
    }

    end {
        $items = Get-GlyFileSystemItems -Path $Path -LiteralPath $LiteralPath -InputObject $pipelineItems
        for ($i = 0; $i -lt $items.Count; $i++) {
            Write-GlyTreeItem -Item $items[$i] -Prefix '' -RemainingDepth $Depth -IsLast ($i -eq ($items.Count - 1)) -IsRoot $true
        }
    }
}
