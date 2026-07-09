$script:GlyModuleRoot = $PSScriptRoot
$script:GlyFormatDataPath = Join-Path $PSScriptRoot 'formats/FileSystem.format.ps1xml'
$script:GlyFormatDataLoaded = $false

Get-ChildItem -Path (Join-Path $PSScriptRoot 'private') -Filter '*.ps1' |
    Sort-Object Name |
    ForEach-Object { . $_.FullName }

Get-ChildItem -Path (Join-Path $PSScriptRoot 'public') -Filter '*.ps1' |
    Sort-Object Name |
    ForEach-Object { . $_.FullName }

Initialize-GlyConfiguration
Initialize-GlyThemes
Initialize-GlyGlyphSets
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
    'Show-Gly',
    'Show-GlyTree',
    'Show-GlyGrid',
    'Get-GlyFileSystemDisplayName'
) -Alias @('gly', 'glytr', 'glygr')
