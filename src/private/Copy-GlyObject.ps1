function Copy-GlyObject {
  param(
    [AllowNull()]
    [object] $InputObject
  )

  if ($null -eq $InputObject) {
    return $null
  }

  if ($InputObject -is [System.Collections.IDictionary]) {
    $copy = [ordered]@{}
    foreach ($key in $InputObject.Keys) {
      $copy[$key] = Copy-GlyObject -InputObject $InputObject[$key]
    }
    return $copy
  }

  if ($InputObject -is [pscustomobject]) {
    $copy = [ordered]@{}
    foreach ($property in $InputObject.PSObject.Properties) {
      $copy[$property.Name] = Copy-GlyObject -InputObject $property.Value
    }
    return $copy
  }

  if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
    $items = @()
    foreach ($item in $InputObject) {
      $items += Copy-GlyObject -InputObject $item
    }
    return $items
  }

  return $InputObject
}
