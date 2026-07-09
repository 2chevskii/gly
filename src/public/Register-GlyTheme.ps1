function Register-GlyTheme {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [object] $Theme
  )

  process {
    Test-GlyTheme -Theme $Theme | Out-Null
    $copy = ConvertTo-GlyTheme -Theme $Theme
    $name = $copy.Name

    if ($script:GlyThemes.Contains($name) -and $script:GlyThemes[$name].BuiltIn) {
      throw "Built-in gly theme '$name' cannot be overwritten. Use Copy-GlyTheme with a new name."
    }

    $copy.BuiltIn = $false
    $script:GlyThemes[$name] = $copy
    ConvertTo-GlyTheme -Theme $copy
  }
}
