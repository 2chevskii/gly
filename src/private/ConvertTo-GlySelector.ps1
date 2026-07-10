function ConvertTo-GlySelector {
  param(
    [Parameter(Mandatory)]
    [object] $Selector
  )

  $result = [GlySelector]::new()
  $kind = Get-GlyValue -InputObject $Selector -Name 'Kind'
  if ($null -ne $kind -and -not [string]::IsNullOrWhiteSpace([string] $kind)) {
    $kindText = [string] $kind
    if ($kindText -cnotin [GlyFileSystemKind].GetEnumNames()) {
      throw "Invalid selector Kind '$kindText'. Valid values: $([GlyFileSystemKind].GetEnumNames() -join ', ')."
    }
    $result.Kind = [GlyFileSystemKind] $kindText
  }

  $name = Get-GlyValue -InputObject $Selector -Name 'Name'
  if ($null -ne $name) {
    $result.Name = [string] $name
  }

  $extension = Get-GlyValue -InputObject $Selector -Name 'Extension'
  if ($null -ne $extension) {
    $result.Extension = [string[]] @($extension)
  }

  $glob = Get-GlyValue -InputObject $Selector -Name 'Glob'
  if ($null -ne $glob) {
    $result.Glob = [string[]] @($glob)
  }

  $attributes = Get-GlyValue -InputObject $Selector -Name 'Attributes'
  if ($null -ne $attributes) {
    try {
      $result.Attributes = [System.IO.FileAttributes[]] @($attributes)
    }
    catch {
      throw "Invalid selector Attributes value: $($_.Exception.Message)"
    }
  }

  return Initialize-GlySelector -Selector $result
}
