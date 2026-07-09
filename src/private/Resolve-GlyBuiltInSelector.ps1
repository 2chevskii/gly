function Resolve-GlyBuiltInSelector {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  $index = Get-GlyBuiltInSelectorIndex
  $best = $null
  $kind = Get-GlyFileSystemKind -InputObject $InputObject
  $name = $InputObject.Name

  $candidate = $index.Kind[$kind]
  if ($null -ne $candidate) {
    $best = $candidate
  }

  $candidate = $index.Name[$name]
  if ($null -ne $candidate -and ($null -eq $best -or $candidate.Index -gt $best.Index)) {
    $best = $candidate
  }

  $dot = $name.IndexOf('.')
  while ($dot -ge 0) {
    $candidate = $index.Extension[$name.Substring($dot)]
    if ($null -ne $candidate -and ($null -eq $best -or $candidate.Index -gt $best.Index)) {
      $best = $candidate
    }
    $dot = $name.IndexOf('.', $dot + 1)
  }

  foreach ($globKind in @($kind, '*')) {
    $candidate = $index.GlobExact["$globKind`0$name"]
    if ($null -ne $candidate -and ($null -eq $best -or $candidate.Index -gt $best.Index)) {
      $best = $candidate
    }

    $regex = $index.GlobRegex[$globKind]
    if ($null -ne $regex) {
      $match = $regex.Match($name)
      if ($match.Success) {
        foreach ($definition in $index.GlobRegexDefinitions[$globKind]) {
          if ($match.Groups["g$($definition.Index)"].Success) {
            if ($null -eq $best -or $definition.Index -gt $best.Index) {
              $best = $definition
            }
            break
          }
        }
      }
    }
  }

  foreach ($definition in $index.Attributes) {
    $matches = $true
    foreach ($attribute in $definition.Selector.Attributes) {
      if (($InputObject.Attributes -band $attribute) -eq 0) {
        $matches = $false
        break
      }
    }
    if ($matches -and ($null -eq $best -or $definition.Index -gt $best.Index)) {
      $best = $definition
    }
  }

  foreach ($definition in $index.Other) {
    if (($null -eq $best -or $definition.Index -gt $best.Index) -and
      (Test-GlyRuleSelector -Selector $definition.Selector -InputObject $InputObject)) {
      $best = $definition
    }
  }

  return $best
}
