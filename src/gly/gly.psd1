@{
    RootModule = 'gly.psm1'
    ModuleVersion = '0.1.0'
    GUID = '9b89b623-fc6e-4c5d-94a8-89d76bf2ce98'
    Author = '2CHEVSKII'
    CompanyName = 'Unknown'
    Copyright = '(c) 2026 2CHEVSKII. All rights reserved.'
    Description = 'Custom visual formatting for PowerShell file system objects.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @(
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
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @('gly', 'glytr', 'glygr')
    PrivateData = @{
        PSData = @{
            Tags = @('PowerShell', 'FileSystem', 'Formatting', 'Glyphs')
            LicenseUri = ''
            ProjectUri = ''
            ReleaseNotes = 'Initial MVP implementation.'
        }
    }
}
