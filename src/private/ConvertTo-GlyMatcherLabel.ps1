function ConvertTo-GlyMatcherLabel {
  param(
    [GlySelector] $Selector
  )

  if ($null -eq $Selector) {
    return 'Default'
  }

  $signature = ConvertTo-GlySelectorSignature -Selector $Selector
  if ($null -eq $script:GlyBuiltInMatcherLabels) {
    $script:GlyBuiltInMatcherLabels = @{}
    foreach ($definition in Get-GlyBuiltInSelectorCatalog) {
      $definitionSignature = ConvertTo-GlySelectorSignature -Selector $definition.Selector
      $script:GlyBuiltInMatcherLabels[$definitionSignature] = $definition.Token
    }
  }
  if ($script:GlyBuiltInMatcherLabels.ContainsKey($signature)) {
    return $script:GlyBuiltInMatcherLabels[$signature]
  }

  $parts = @()
  if ($null -ne $Selector.Kind) { $parts += "Kind=$($Selector.Kind)" }
  if (-not [string]::IsNullOrWhiteSpace($Selector.Name)) { $parts += "Name=$($Selector.Name)" }
  if ($Selector.Extension.Count -gt 0) { $parts += "Extension=$($Selector.Extension -join ',')" }
  if ($Selector.Glob.Count -gt 0) { $parts += "Glob=$($Selector.Glob -join ',')" }
  if ($Selector.Attributes.Count -gt 0) { $parts += "Attributes=$($Selector.Attributes -join ',')" }
  return $parts -join '; '
}
