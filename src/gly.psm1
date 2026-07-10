$script:GlyModuleRoot = $PSScriptRoot
$script:GlyFormatDataPath = Join-Path $PSScriptRoot 'formats/FileSystem.format.ps1xml'
$script:GlyFormatDataLoaded = $false
$script:GlyBuiltInSelectorCatalog = $null
$script:GlyBuiltInSelectorIndex = $null
$script:GlyBuiltInMatcherLabels = $null

# Parsing one combined script block avoids per-file parser and dot-sourcing overhead during import.
$sourceBuilder = [System.Text.StringBuilder]::new()
[void] $sourceBuilder.AppendLine([System.IO.File]::ReadAllText((Join-Path $PSScriptRoot 'GlyTypes.ps1')))
foreach ($directory in @('private', 'public')) {
  foreach ($path in [System.IO.Directory]::GetFiles((Join-Path $PSScriptRoot $directory), '*.ps1')) {
    [void] $sourceBuilder.AppendLine([System.IO.File]::ReadAllText($path))
  }
}
. ([scriptblock]::Create($sourceBuilder.ToString()))
Remove-Variable sourceBuilder, directory, path

Initialize-GlyConfiguration
Initialize-GlyThemeRegistry
Initialize-GlyGlyphSetRegistry
Enable-Gly

Set-Alias -Name gly -Value Show-Gly
Set-Alias -Name glytr -Value Show-GlyTree
Set-Alias -Name glygr -Value Show-GlyGrid

Export-ModuleMember -Function @(
  'Enable-Gly',
  'Disable-Gly',
  'Get-GlyConfiguration',
  'Set-GlyConfiguration',
  'Get-GlyTheme',
  'Set-GlyTheme',
  'Register-GlyTheme',
  'Copy-GlyTheme',
  'Get-GlyGlyphSet',
  'Set-GlyGlyphSet',
  'Register-GlyGlyphSet',
  'Copy-GlyGlyphSet',
  'Show-GlyThemeColor',
  'Show-GlyGlyph',
  'Show-GlyThemePreview',
  'Show-Gly',
  'Show-GlyTree',
  'Show-GlyGrid',
  'Get-GlyFileSystemDisplayName'
) -Alias @('gly', 'glytr', 'glygr')
