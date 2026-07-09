function Resolve-GlyFileSystemRule {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo] $InputObject,

        [Parameter(Mandatory)]
        [object[]] $Rules
    )

    $matchedRule = $null
    foreach ($rule in @($Rules)) {
        $selector = Get-GlyValue -InputObject $rule -Name 'Selector'
        if ($null -eq $selector) {
            continue
        }

        try {
            if (Test-GlyRuleSelector -Selector $selector -InputObject $InputObject) {
                $matchedRule = $rule
            }
        } catch {
            continue
        }
    }

    return $matchedRule
}
