function Test-GlyRuleSelector {
  param(
    [Parameter(Mandatory)]
    [GlySelector] $Selector,

    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo] $InputObject
  )

  $kind = Get-GlyFileSystemKind -InputObject $InputObject

  if ($null -ne $Selector.Kind -and $Selector.Kind.ToString() -cne $kind) {
    return $false
  }

  if ($null -ne $Selector.Name -and $Selector.Name -cne $InputObject.Name) {
    return $false
  }

  if ($Selector.NormalizedExtension.Count -gt 0) {
    $name = $InputObject.Name
    $matched = $false
    foreach ($extension in $Selector.NormalizedExtension) {
      if ($name.EndsWith($extension, [System.StringComparison]::OrdinalIgnoreCase)) {
        $matched = $true
        break
      }
    }

    if (-not $matched) {
      return $false
    }
  }

  if ($Selector.GlobPattern.Count -gt 0) {
    $globMatched = $false
    foreach ($pattern in $Selector.GlobPattern) {
      if ($pattern.IsMatch($InputObject.Name) -or $pattern.IsMatch($InputObject.FullName)) {
        $globMatched = $true
        break
      }
    }

    if (-not $globMatched) {
      return $false
    }
  }

  if ($Selector.Attributes.Count -gt 0) {
    foreach ($attribute in $Selector.Attributes) {
      if (($InputObject.Attributes -band $attribute) -eq 0) {
        return $false
      }
    }
  }

  return $true
}
