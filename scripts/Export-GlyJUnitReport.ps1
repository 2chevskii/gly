function Export-GlyJUnitReport {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [Pester.Run] $Result,

    [Parameter(Mandatory)]
    [string] $Path
  )

  $pending = [System.Collections.Generic.Queue[object]]::new()
  foreach ($container in $Result.Containers) {
    $pending.Enqueue($container)
  }
  $originalValues = [System.Collections.Generic.List[object]]::new()

  try {
    while ($pending.Count -gt 0) {
      $node = $pending.Dequeue()
      foreach ($errorRecord in $node.ErrorRecord) {
        foreach ($propertyName in @('DisplayErrorMessage', 'DisplayStackTrace')) {
          $property = $errorRecord.PSObject.Properties[$propertyName]
          if ($null -eq $property -or $null -eq $property.Value) {
            continue
          }

          $originalValues.Add([pscustomobject]@{
            Property = $property
            Value = $property.Value
          })
          # XML 1.0 rejects ESC and other control characters even in failure messages.
          # Preserve their values as readable escapes for ANSI diagnostics.
          $property.Value = [regex]::Replace(
            [string] $property.Value,
            '[\x00-\x08\x0B\x0C\x0E-\x1F\uFFFE\uFFFF]',
            [System.Text.RegularExpressions.MatchEvaluator] {
              param($match)
              return '\u{0:x4}' -f [int][char]$match.Value
            }
          )
        }
      }

      foreach ($childPropertyName in @('Blocks', 'Tests')) {
        $childProperty = $node.PSObject.Properties[$childPropertyName]
        if ($null -ne $childProperty) {
          foreach ($child in $childProperty.Value) {
            $pending.Enqueue($child)
          }
        }
      }
    }

    Export-JUnitReport -Result $Result -Path $Path
  }
  finally {
    foreach ($original in $originalValues) {
      $original.Property.Value = $original.Value
    }
  }
}
