function Get-GlyRegistryNameCompletion {
  param(
    [Parameter(Mandatory)]
    [System.Collections.IDictionary] $Registry,

    [Parameter(Mandatory)]
    [string] $WordToComplete,

    [Parameter(Mandatory)]
    [string] $ItemLabel
  )

  $prefix = $WordToComplete.TrimStart([char[]] @("'", '"'))
  $escapedPrefix = [System.Management.Automation.WildcardPattern]::Escape($prefix)

  foreach ($name in $Registry.Keys) {
    if ($name -notlike "$escapedPrefix*") {
      continue
    }

    $completionText = "'$($name -replace "'", "''")'"
    $origin = if ($Registry[$name].BuiltIn) { 'Built-in' } else { 'Registered' }

    [System.Management.Automation.CompletionResult]::new(
      $completionText,
      $name,
      [System.Management.Automation.CompletionResultType]::ParameterValue,
      "$origin gly $ItemLabel"
    )
  }
}
