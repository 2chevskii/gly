function Get-GlyFileSystemDisplayName {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [System.IO.FileSystemInfo] $InputObject
  )

  process {
    try {
      $name = $InputObject.Name + (Get-GlyLinkSuffix -InputObject $InputObject)
      if (-not $script:GlyConfiguration.Enabled) {
        return $name
      }

      $glyph = Get-GlyFileSystemGlyph -InputObject $InputObject
      $displayName = if ([string]::IsNullOrEmpty($glyph)) { $name } else { "$glyph $name" }

      $style = Get-GlyFileSystemStyle -InputObject $InputObject
      $renderer = Resolve-GlyStyleRenderer
      if ($renderer -eq 'PlainText') {
        return $displayName
      }

      $prefix = if ($renderer -eq 'PSStyle') {
        ConvertTo-GlyPSStyle -Style $style
      }
      else {
        ConvertTo-GlyAnsiStyle -Style $style
      }

      if ([string]::IsNullOrEmpty($prefix)) {
        return $displayName
      }

      $reset = if ($script:GlyConfiguration.ResetAfterName) { "$([char]27)[0m" } else { '' }
      return "$prefix$displayName$reset"
    }
    catch {
      return $InputObject.Name
    }
  }
}
