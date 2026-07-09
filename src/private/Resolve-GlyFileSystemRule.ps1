function Resolve-GlyFileSystemRule {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject,

    [Parameter(Mandatory)]
    [object[]] $Rules
  )

  $ruleList = @($Rules)
  for ($i = $ruleList.Count - 1; $i -ge 0; $i--) {
    $rule = $ruleList[$i]
    $selector = $rule.Selector
    if ($null -eq $selector) {
      continue
    }

    try {
      if (Test-GlyRuleSelector -Selector $selector -InputObject $InputObject) {
        return $rule
      }
    }
    catch {
      continue
    }
  }

  return $null
}
