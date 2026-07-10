function Get-GlyBuiltInSelectorIndex {
  if ($null -ne $script:GlyBuiltInSelectorIndex) {
    return $script:GlyBuiltInSelectorIndex
  }

  $index = [pscustomobject]@{
    Kind                 = @{}
    Name                 = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::Ordinal)
    Extension            = @{}
    GlobExact            = @{}
    GlobRegex            = @{}
    GlobRegexDefinitions = @{}
    Attributes           = [System.Collections.Generic.List[object]]::new()
    Other                = [System.Collections.Generic.List[object]]::new()
  }
  $wildcardGlob = @{}

  foreach ($definition in Get-GlyBuiltInSelectorCatalog) {
    $selector = $definition.Selector
    if ($selector.Glob.Count -gt 0) {
      $kind = if ($null -ne $selector.Kind) { $selector.Kind.ToString() } else { '*' }
      foreach ($glob in $selector.Glob) {
        if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($glob)) {
          if (-not $wildcardGlob.ContainsKey($kind)) {
            $wildcardGlob[$kind] = [System.Collections.Generic.List[object]]::new()
          }
          $wildcardGlob[$kind].Add([pscustomobject]@{
              Definition = $definition
              Glob       = $glob
            })
        }
        else {
          $key = "$kind`0$glob"
          $existing = $index.GlobExact[$key]
          if ($null -eq $existing -or $definition.Index -gt $existing.Index) {
            $index.GlobExact[$key] = $definition
          }
        }
      }
      continue
    }

    if (-not [string]::IsNullOrEmpty($selector.Name)) {
      $existing = $index.Name[$selector.Name]
      if ($null -eq $existing -or $definition.Index -gt $existing.Index) {
        $index.Name[$selector.Name] = $definition
      }
      continue
    }

    if ($selector.NormalizedExtension.Count -gt 0) {
      foreach ($extension in $selector.NormalizedExtension) {
        $existing = $index.Extension[$extension]
        if ($null -eq $existing -or $definition.Index -gt $existing.Index) {
          $index.Extension[$extension] = $definition
        }
      }
      continue
    }

    if ($selector.Attributes.Count -gt 0) {
      $index.Attributes.Add($definition)
      continue
    }

    if ($null -ne $selector.Kind) {
      $kind = $selector.Kind.ToString()
      $existing = $index.Kind[$kind]
      if ($null -eq $existing -or $definition.Index -gt $existing.Index) {
        $index.Kind[$kind] = $definition
      }
      continue
    }

    $index.Other.Add($definition)
  }

  foreach ($kind in $wildcardGlob.Keys) {
    $records = @($wildcardGlob[$kind] | Sort-Object { $_.Definition.Index } -Descending)
    $alternatives = foreach ($record in $records) {
      $pattern = [System.Text.RegularExpressions.Regex]::Escape($record.Glob).
        Replace('\*', '.*').
        Replace('\?', '.')
      "(?<g$($record.Definition.Index)>$pattern)"
    }
    $index.GlobRegex[$kind] = [System.Text.RegularExpressions.Regex]::new(
      "\A(?:$($alternatives -join '|'))\z",
      [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor
        [System.Text.RegularExpressions.RegexOptions]::CultureInvariant -bor
        [System.Text.RegularExpressions.RegexOptions]::Compiled
    )
    $index.GlobRegexDefinitions[$kind] = @(
      $records.Definition | Sort-Object Index -Descending -Unique
    )
  }

  $script:GlyBuiltInSelectorIndex = $index
  return $index
}
