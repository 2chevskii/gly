function Initialize-GlySelector {
  param(
    [Parameter(Mandatory)]
    [GlySelector] $Selector
  )

  $Selector.NormalizedExtension = [string[]] @(
    foreach ($extension in $Selector.Extension) {
      $value = [string] $extension
      if (-not $value.StartsWith('.')) {
        $value = ".$value"
      }
      $value
    }
  )

  $Selector.GlobPattern = [System.Management.Automation.WildcardPattern[]] @(
    foreach ($glob in $Selector.Glob) {
      [System.Management.Automation.WildcardPattern]::new(
        [string] $glob,
        [System.Management.Automation.WildcardOptions]::IgnoreCase
      )
    }
  )

  return $Selector
}
