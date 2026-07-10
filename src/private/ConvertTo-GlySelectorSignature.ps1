function ConvertTo-GlySelectorSignature {
  param(
    [Parameter(Mandatory)]
    [GlySelector] $Selector
  )

  $kind = if ($null -ne $Selector.Kind) { [string] $Selector.Kind } else { '' }
  $name = if ($null -ne $Selector.Name) { $Selector.Name.ToLowerInvariant() } else { '' }
  $extensions = @($Selector.Extension | ForEach-Object { $_.ToLowerInvariant() } | Sort-Object) -join ','
  $globs = @($Selector.Glob | ForEach-Object { $_.ToLowerInvariant() } | Sort-Object) -join ','
  $attributes = @($Selector.Attributes | ForEach-Object { [string] $_ } | Sort-Object) -join ','

  return "Kind=$kind|Name=$name|Extension=$extensions|Glob=$globs|Attributes=$attributes"
}
